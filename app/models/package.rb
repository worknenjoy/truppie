class Package < ActiveRecord::Base
  
  has_and_belongs_to_many :tours
  has_and_belongs_to_many :guidebooks
  
  def price
    case self.try(:currency)
    when 'BRL'
      "<small>R$</small> " + self.value.to_s
    when 'US'
      "<small>$</small> " + self.value.to_s
    when 'EURO'
      "<small>€</small> " + self.value.to_s
      else
      # get the right currency
      "<small>R$</small> " + self.value.to_s
    end
  end
  
  
end
