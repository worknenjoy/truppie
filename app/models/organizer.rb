class Organizer < ActiveRecord::Base
  has_many :tours  
  has_and_belongs_to_many :members
  
  belongs_to :user
  belongs_to :where
  
  
  def to_param
    "#{id} #{name}".parameterize
  end
  
  # This method associates the attribute ":picture" with a file attachment
  has_attached_file :picture, styles: {
    thumbnail: '300x300>',
    square: '400x400#',
    cover: '600x800>',
    medium: '500x500>',
    large: '800x800>',
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  
  def bank_data
    {
      "email" => {
          "address" => self.email
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
          "birthDate" => self.birthDate,
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
  
  def bank_info
    {
      "id" => self.account_id,
      "token" => self.token
    }
  end
  
  def phone_object
    if self.phone 
      pn = self.phone.split(' ')
      
      area = pn[1].slice(1..-1)
      areaCode = area.chop
      
      puts areaCode.inspect
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
  
  def valid_account
    !self.bank_data["person"]["name"].nil? && !self.bank_data["person"]["taxDocument"]["number"].nil? && !self.bank_data["person"]["birthDate"].nil?
  end
  
end
