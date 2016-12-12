class ContactMailer < ApplicationMailer
  def send_form(params)
    mail(from: params[:email], subject: params[:subject], body: "#{params[:name]} enviou \n #{params[:body]}", to: 'ola@truppie.com')
  end
  
  def notify(text, tour = nil)
    if !tour.nil?
      mail(from: "ola@truppie", subject: "Algo errado na tentativa de pagamento para a sua truppie - #{tour.title}", body: "Olá #{tour.organizer.name}, #{text}", to: "ola@truppie.com,#{tour.organizer.email}")
    else
      mail(from: "ola@truppie", subject: "Algo errado na tentativa de pagamento", body: text, to: 'ola@truppie.com')    
    end
  end
  
end
