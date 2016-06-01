class CreditCardStatusMailer < ApplicationMailer
  
  def status_change(status, order, user, tour, organizer)
    @order = order
    @status = status
    @user = user
    @tour = tour
    @organizer = organizer
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com" 
    
    mailers = "#{user.email}"
    
    #@logo = File.basename(@organizer.logo)
    #attachments[@logo] = File.read("app/#{@organizer.logo}")
    
    @logo_file = "#{@organizer.to_param}.png"
    
    #debugger
    
    if @organizer.picture.present?
      attachments[@logo_file] = File.read(@organizer.picture.url(:thumbnail))
    else
      attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
    end
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: @status[:subject],
      to: mailers,
      bcc: copy_mailers,
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
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com"
    
    organizer_mailers = "#{organizer.email}"
    
    @logo_file = "#{@organizer.to_param}.png"
    
    if @organizer.picture.present?
      attachments[@logo_file] = @organizer.picture.url(:thumbnail)
    else
      attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
    end
    
    #CreditCardStatusMailer.status_change(@status, Order.last, User.find(2), Tour.find(11), Organizer.last).deliver_now
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: "Notificação enviada ao usuário da sua truppie - #{@status[:subject]}",
      to: organizer_mailers,
      bcc: copy_mailers,
      template_name: @status[:guide],
      template_path: 'credit_card_status_mailer/guide'
     )
  end
  
  def status_message(message)
    mail(
      from: 'ola@truppie.com',
      subject: 'Foi enviada uma requisição ao acessar o webhook que não pode ser processada',
      to: 'ola@truppie.com',
      body: message 
     )
  end
  
end
