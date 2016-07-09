class BankAccount < ActiveRecord::Base
  belongs_to :organizer
  validates :bankNumber, presence: true
  validates :agencyNumber, presence: true
  validates :accountNumber, presence: true
  
  
  def account_info
    {
      "bankNumber" => self.bankNumber,
      "agencyNumber" => self.agencyNumber,
      "accountNumber" => self.accountNumber,
      "agencyCheckNumber" => self.agencyCheckNumber,
      "accountCheckNumber" => self.accountCheckNumber,
      "type" => "CHECKING",
      "holder" => {
        "taxDocument" => {
          "type" => self.doc_type,
          "number" => self.doc_number
        },
        "fullname" => self.fullname
      }
    }
  end
  
end
