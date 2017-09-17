class BankAccount < ActiveRecord::Base

  belongs_to :marketplace

  validates :bank_number, presence: true, :allow_blank => false
  validates :agency_number, presence: true, :allow_blank => false
  validates :account_number, presence: true, :allow_blank => false
  validates :fullname, presence: true, :allow_blank => false

  def register
    account = self.from_account
    bank_account = account.external_accounts.create(external_account: self.bank_account_format)
    if bank_account and bank_account.id
      update_attributes({
          :own_id => bank_account.id
      })
    end
    return bank_account
  end

  def name
    ApplicationController.helpers.bank_list["banks"][self.bank_number]
  end

  def is_registered?
    self.status == 'new'
  end

  def status
    begin
      self.fetch.status
    rescue => e
      e
    end
  end

  def from_account
    self.marketplace.retrieve_account
  end

  def fetch
    self.from_account.external_accounts.retrieve(self.own_id)
  end

  def sync
    if self.own_id
      bank_account = self.fetch
      bank_account.default_for_currency = self.active || false
      #bank_account.metadata['id'] = self.id
      #bank_account.metadata['marketplace'] = self.marketplace.id
      bank_account.save
      bank_account
    else
      raise ArgumentError.new('It needs an id')
    end
  end

  def routing_number
    "#{self.bank_number}-#{self.agency_number}"
  end

  def bank_account_format
    return {
        object: "bank_account",
        account_number: self.account_number,
        default_for_currency: true,
        country: self.marketplace.country,
        currency: "BRL",
        account_holder_name: self.fullname,
        account_holder_type: self.marketplace.organizer_type,
        routing_number: "#{self.bank_number}-#{self.agency_number}"
    }
  end


  
end
