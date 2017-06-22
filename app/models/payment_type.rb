class PaymentType < ActiveRecord::Base
  belongs_to :marketplace


  def auth_url
    "https://pagseguro.uol.com.br/v2/authorization/request.jhtml?code=#{self.auth}"
  end

end
