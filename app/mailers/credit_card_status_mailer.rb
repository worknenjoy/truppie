class CreditCardStatusMailer < ApplicationMailer
  
  def status_change(payment)
    mail(from: 'ola@truppie.com', subject: 'cartao de credito', body: payment, to: 'alexanmtz@gmail.com')
  end
  
end
