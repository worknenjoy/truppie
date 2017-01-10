class BankAccount < ActiveRecord::Base
  belongs_to :marketplace

  validates :bankNumber, presence: true
  validates :agencyNumber, presence: true
  validates :accountNumber, presence: true
  
end
