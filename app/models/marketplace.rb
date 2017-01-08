class Marketplace < ActiveRecord::Base
  belongs_to :organizer
  has_and_belongs_to_many :bank_accounts
  
  
  accepts_nested_attributes_for :bank_accounts, :allow_destroy => true
  
end
