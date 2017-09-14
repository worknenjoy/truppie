require 'json'

class Marketplace < ActiveRecord::Base
  belongs_to :organizer
  has_and_belongs_to_many :bank_accounts
  has_and_belongs_to_many :payment_types
  
  accepts_nested_attributes_for :bank_accounts, :allow_destroy => true
  accepts_nested_attributes_for :payment_types, :allow_destroy => true
  
   has_attached_file :photo, styles: {
    thumbnail: '300x300>',
    square: '400x400#',
    cover: '600x800>',
    medium: '500x500>',
    large: '800x800>',
  }

  validates_presence_of :person_name, :birthDate, :person_lastname, :document_number, :document_type, :street, :complement, :zipcode, :city, :state, :organizer, :allow_blank => false
  
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  
  def account
    {
      :country => "BR",
      :managed => true,
      :email => self.organizer.email,
      :business_url => self.organizer.website,
      :business_name => self.organizer.name,
      :product_description => self.organizer.description,
      :legal_entity => {
        :first_name => self.person_name,
        :last_name => self.person_lastname,
        :personal_id_number => self.document_number,
        :dob => {
          :day => self.dob[:day],
          :month => self.dob[:month],
          :year => self.dob[:year]
        },
        :type => self.organizer_type,
        :personal_address => {
          :city => self.city,
          :country => self.country,
          :line1 => self.street,
          :line2 => self.complement,
          :state => self.state,
          :postal_code => self.zipcode
         },
         :address => {
          :city => self.city,
          :country => self.country,
          :line1 => self.street,
          :line2 => self.complement,
          :state => self.state,
          :postal_code => self.zipcode
         }
      }
    }
  end
  
  def document_picture 
    if self.photo.present?
      self.try(:document) if self.retrieve_account.legal_entity.verification.document
    end
  end
  
  def bank_name
    bank_list["banks"][self.bank_account.bank_number]
  end
  
  def activate
    if self.is_active?
      false  
    else
      account = Stripe::Account.create(self.account)
      if !account.id.nil? && !account.keys.secret.nil?
        update_attributes(
          :account_id => account.id,
          :token => account.keys.secret,
          :active => true
        )
      end
      return account
    end
  end
  
  def uploads
    begin
      Stripe::FileUpload.list
    rescue => e
      e
    end
  end
  
  def update_account
    if !self.is_active?
      false  
    else
      account = Stripe::Account.retrieve(self.account_id)
      account.business_url = self.organizer.website if account.business_url.nil?
      account.legal_entity.first_name = self.person_name if account.legal_entity.first_name != self.person_name
      account.legal_entity.last_name = self.person_lastname if account.legal_entity.last_name != self.person_lastname
      account.legal_entity.dob = self.dob if account.legal_entity.dob != self.dob
      account.legal_entity.personal_id_number = self.document_number

      account.legal_entity.personal_address.city = self.city if account.legal_entity.personal_address.city != self.city
      account.legal_entity.personal_address.country = self.country
      account.legal_entity.personal_address.line1 = self.street if account.legal_entity.personal_address.line1 != self.street
      account.legal_entity.personal_address.line2 = self.complement if account.legal_entity.personal_address.line2 != self.complement
      account.legal_entity.personal_address.state = self.state if account.legal_entity.personal_address.state != self.state
      account.legal_entity.personal_address.postal_code = self.zipcode if account.legal_entity.personal_address.postal_code != self.zipcode
      
      if self.organizer_type == 'individual'
        account.legal_entity.address.city = self.city if account.legal_entity.address.city != self.city
        account.legal_entity.address.country = self.country if account.legal_entity.address.country != self.country
        account.legal_entity.address.line1 = self.street if account.legal_entity.address.line1 != self.street
        account.legal_entity.address.line2 = self.complement if account.legal_entity.address.line2 != self.complement
        account.legal_entity.address.state = self.state if account.legal_entity.address.state != self.state
        account.legal_entity.address.postal_code = self.zipcode if account.legal_entity.address.postal_code != self.zipcode
      else
        account.legal_entity.address.city = self.company_city if account.legal_entity.address.city != self.company_city
        account.legal_entity.address.country = self.company_country if account.legal_entity.address.country != self.company_country
        account.legal_entity.address.line1 = self.company_street if account.legal_entity.address.line1 != self.company_street
        account.legal_entity.address.line2 = self.compcompany_complement if account.legal_entity.address.line2 != self.compcompany_complement
        account.legal_entity.address.state = self.company_state if account.legal_entity.address.state != self.company_state
        account.legal_entity.address.postal_code = self.company_zipcode if account.legal_entity.address.postal_code != self.company_zipcode
      end
      
      account.product_description = self.organizer.description if account.product_description.nil?
      account.legal_entity.type = self.organizer_type if account.legal_entity.type != self.organizer_type
      
      if self.photo.present?
        begin
          upload = Stripe::FileUpload.create({
              :file => open(photo.url),
              :purpose => "identity_document"
          }, {:stripe_account => self.account_id})
          account.legal_entity.verification.document = upload.id
        rescue => e
          ContactMailer.notify("Houve uma tentativa de enviar a foto pois #{e.inspect}").deliver_now
        end
      end
      account.save
      return account
    end
  end
  
  def deactivate
    if self.is_active?
      begin
        account = Stripe::Account.retrieve(self.account)
      rescue => e
        return e
      end
      deleted = account.delete
      return deleted
    else
      false
    end
  end
  
  def retrieve_account
    account = Stripe::Account.retrieve(self.account_id)
    return account
  end
  
  def organizer_type 
    if self.business
      "company"
    else
      "individual"
    end
  end
  
  def dob
    date = self.birthDate
    {
      day: date.day,
      month: date.month,
      year: date.year
    }
  end
  
  def balance
    bank_account = Stripe::Balance.retrieve({:stripe_account => self.account_id})
    #puts bank_account.inspect
    return bank_account
  end
   
  def account_info
    {
      "email" => {
          "address" => self.organizer.email
      },
      "person" => {
          "name" => self.person_name,
          "lastName" => self.person_lastname,
          "taxDocument" => {
              "type" => self.document_type,
              "number"=> self.document_number
          },
          "identityDocument"=> {
              "type"=> self.id_type,
              "number"=> self.id_number,
              "issuer"=> self.id_issuer,
              "issueDate"=> self.id_issuerdate
          },
          "birthDate" => self.birthDate.strftime('%Y-%m-%d'),
          "phone" => self.phone_object,
          "address" => {
              "street" => self.street,
              "streetNumber" => self.street_number,
              "complement"=> self.complement,
              "district" => self.district,
              "zipcode" => self.zipcode,
              "city" => self.city,
              "state" => self.state,
              "country" => self.country
          }
      },
      "businessSegment" => {
          "id" => "37"
      },
      "site" => "http://www.truppie.com",
      "type" => "MERCHANT",
      "transparentAccount" => "true"
    }
  end
  
  def account_missing
    if is_active?
      begin
        account = Stripe::Account.retrieve(self.account_id)
        if account.id
          return account.verification
        end
      rescue => e
        puts e.inspect
        return ["not active account"]
      end
    end 
  end

  def account_needed
    account_missing = self.account_missing

    account_missing_details = []

    account_missing[:fields_needed].each do |f|
      account_missing_details.push({
        name: f,
        label: I18n.t("account-missing-#{f.dasherize}-label"),
        message: I18n.t("account-missing-#{f.dasherize}-message")
      })
    end
    return account_missing_details
  end

  def account_full_verified
    begin
      account_missing = self.account_missing
      if account_missing[:fields_needed].empty?
        return true
      end
      return false
    rescue
      return false
    end
  end
  
  def transfers
    transfer_history = Stripe::Transfer.list(limit: 10, destination: self.account_id)
    #puts transfer_history.inspect
    return transfer_history
  end
  
  def bank_account_active
    self.bank_accounts.where(:active => true).first
  end
  
  def bank_account
    bank_account_active = self.bank_account_active
    return {
      object: "bank_account",
      account_number: bank_account_active.account_number,
      default_for_currency: true,
      country: self.country,
      currency: "BRL",
      account_holder_name: bank_account_active.fullname,
      account_holder_type: self.organizer_type,
      routing_number: "#{bank_account_active.bank_number}-#{bank_account_active.agency_number}"
    }
  end
  
  def delete_bank_account
    account = Stripe::Account.retrieve(self.account_id)
    deleted = account.external_accounts.retrieve("ba_19mVhuEiJRT3FkN7hBYpgjRJ").delete()
    return deleted
  end
  
  def registered_bank_account
    if is_active?
      begin
        bank_accounts = Stripe::Account.retrieve(self.account_id).external_accounts
        if bank_accounts.total_count
          return bank_accounts.data
        end
      rescue => e
        puts "bank accounts"
        puts e.inspect
        return e
      end
    end   
  end
  
  def register_bank_account
    account = Stripe::Account.retrieve(self.account_id)
    bank_account = account.external_accounts.create(external_account: self.bank_account)
    return bank_account
  end
  
  def phone_object
    if !self.organizer.phone.empty?
      pn = self.organizer.phone.split(' ')
      
      area = pn[1].slice(1..-1)
      areaCode = area.chop
      
      {
        "countryCode" => pn[0].slice(1..-1),
        "areaCode"=> areaCode,
        "number" => pn[2]
      }
    else
      {
        "countryCode" => "",
        "areaCode"=> "",
        "number" => ""
      }
    end
  end 
  
  def auth_data
    if self.active
      {
        "id" => self.account_id,
        "token" => self.token
      }
    else
      false
    end
  end
  
  def is_active?
    self.auth_data && self.active
  end 
  
  def accept_terms(ip)
    if !self.is_active?
      false  
    else
      account = Stripe::Account.retrieve(self.account_id)
      date_now = Time.now.to_i
      account.tos_acceptance.date = date_now 
      account.tos_acceptance.ip = ip
      account.save
      if account.tos_acceptance.ip == ip && account.tos_acceptance.date == date_now
        return true
      else
        return false
      end
    end
  end

  def payment_types_authorize
      post_params = {
          appId: 'truppie',
          appKey: 'CDEF210C5C5C6DFEE4E36FBE9DB6F509',
      }

      url = "https://ws.pagseguro.uol.com.br/v2/authorizations/request?appId=#{post_params[:appId]}
&appKey=#{post_params[:appKey]}"

      xml = <<EOF
          <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
              <authorizationRequest>
                <reference>#{self.payment_types.first.id}</reference>
                  <permissions>
                    <code>CREATE_CHECKOUTS</code>
                    <code>RECEIVE_TRANSACTION_NOTIFICATIONS</code>
                    <code>SEARCH_TRANSACTIONS</code>
                    <code>MANAGE_PAYMENT_PRE_APPROVALS</code>
                  </permissions>
                  <account>
                    <email>#{self.payment_types.first.email}</email>
                  </account>
                <redirectURL>http://truppie.com/redirect</redirectURL>
                <notificationURL>http://truppie.com/webhook_external_payment</notificationURL>
              </authorizationRequest>
EOF

      begin
        response = RestClient.post url, xml, {content_type: :xml}
        xml_response = Hash.from_xml(response.body).to_json
      rescue => e
        puts e.inspect
      end
      code = JSON.parse(xml_response)['authorizationRequest']['code']
      self.payment_types.first.update_attributes({:auth => code})
      return code
  end
  
end
