class ContactMailer < ApplicationMailer
  def send_form(params)
    mail(from: params[:email], subject: params[:subject], body: "#{params[:name]} enviou \n #{params[:body]}", to: 'ola@truppie.com')
  end

  def send_message(params)
    organizer = Organizer.find params[:organizer_id]
    if !!organizer.try(:user)
      mail(from: 'ola@truppie.com', subject: 'Mensagem de usuário', body: "#{params[:name]} enviou \n #{params[:body]}", to: organizer.try(:user).try(:email))
    end
  end
  
  def notify(text, tour = nil)
    if !tour.nil?
      mail(from: "ola@truppie", subject: "Algo errado na tentativa de pagamento para a sua truppie - #{tour.title}", body: "Olá #{tour.organizer.name}, #{text}", to: "ola@truppie.com,#{tour.organizer.email}")
    else
      mail(from: "ola@truppie", subject: "Uma notificação da truppie", body: text, to: 'ola@truppie.com')
    end
  end
  
end
