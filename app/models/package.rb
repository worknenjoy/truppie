class Package < ActiveRecord::Base
  
  has_and_belongs_to_many :tours
  
  def price
    case self.tours.first.currency
    when 'BRL'
      "<small>R$</small> " + self.value.to_s
    when 'US'
      "<small>$</small> " + self.value.to_s
    when 'EURO'
      "<small>€</small> " + self.value.to_s
    else
      self.value
    end
  end
  
  
end
