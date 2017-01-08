class Marketplace < ActiveRecord::Base
  belongs_to :organizer
  has_and_belongs_to_many :bank_accounts
end
