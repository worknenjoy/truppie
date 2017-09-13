class BankAccount < ActiveRecord::Base
  belongs_to :marketplace

  validates :bank_number, presence: true
  validates :agency_number, presence: true
  validates :account_number, presence: true

  #def fetch
  #
  #end


  
end
