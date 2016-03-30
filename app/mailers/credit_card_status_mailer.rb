class CreditCardStatusMailer < ApplicationMailer
  
  def status_change(status, order, user, tour, organizer)
    @order = order
    @status = status
    @user = user
    @tour = tour
    @organizer = organizer
    
    mailers = "ola@truppie.com, #{user.email}, #{organizer.user.email}"
    
    attachments['logo_utopicos.png'] = File.read(Rails.root.join('app/assets/images/logo_utopicos.png'))
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    
    mail(
      from: 'no-reply@truppie.com',
      subject: @status[:subject],
      to: mailers,
      template_name: 'status_change',
      template_path: 'credit_card_status_mailer' 
     )
  end
  
  def guide_mail(status, order, user, tour, organizer)
    
    @order = order
    @status = status
    @user = user
    @tour = tour
    @organizer = organizer
    
    organizer_mailers = "ola@truppie.com, #{organizer.user.email}"
    
    attachments['logo_utopicos.png'] = File.read(Rails.root.join('app/assets/images/logo_utopicos.png'))
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    
    mail(
      from: 'no-reply@truppie.com',
      subject: "Notificação enviada ao usuário da sua truppie - #{@status[:subject]}",
      to: organizer_mailers,
      template_name: @status[:guide],
      template_path: 'credit_card_status_mailer/guide'
     )
  end
  
  def status_message(message)
    mail(
      from: 'no-reply@truppie.com',
      subject: 'Foi enviada uma requisição ao acessar o webhook que não pode ser processada',
      to: 'ola@truppie.com',
      body: message 
     )
  end
  
end
