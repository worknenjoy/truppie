class Marketplace < ActiveRecord::Base
  belongs_to :organizer
  has_and_belongs_to_many :bank_accounts
  
  
  accepts_nested_attributes_for :bank_accounts, :allow_destroy => true
  
  
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
  
  def bank_account
    bank_account_active = self.bank_accounts.where(:active => true)
    {
      "bankNumber" => bank_account_active.bankNumber,
      "agencyNumber" => bank_account_active.agencyNumber,
      "accountNumber" => bank_account_active.accountNumber,
      "agencyCheckNumber" => bank_account_active.agencyCheckNumber,
      "accountCheckNumber" => bank_account_active.accountCheckNumber,
      "type" => "CHECKING",
      "holder" => {
        "taxDocument" => {
          "type" => bank_account_active.doc_type,
          "number" => bank_account_active.doc_number
        },
        "fullname" => bank_account_active.fullname
      }
    }
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
  
  
end
