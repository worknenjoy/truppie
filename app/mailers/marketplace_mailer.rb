require 'open-uri'

class MarketplaceMailer < ApplicationMailer
  layout 'mail_modern_generic'
  
  def activate(organizer)
    
    @organizer = organizer
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com" 
    
    mailers = "#{organizer.email}"
    subject = "Sua carteira da Truppie foi ativada com sucesso"
    
    @logo_file = "#{@organizer.to_param}.png"
    
    if @organizer.picture.present?
      if Rails.env.development?
        attachments[@logo_file] = @organizer.picture.url(:thumbnail)
      else
        attachments[@logo_file] = open(@organizer.picture.url(:thumbnail)).read
      end
    else
      begin
        attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
      rescue => e
        attachments[@logo_file] = nil
      end
    end
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    attachments['facebook_mail.png'] = File.read(Rails.root.join('app/assets/images/facebook_mail.png'))
    attachments['instagram_mail.png'] = File.read(Rails.root.join('app/assets/images/instagram_mail.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: subject,
      to: mailers,
      bcc: copy_mailers,
      template_name: 'activate',
      template_path: 'marketplace_mailer' 
     )
  end
  
  def update(organizer)
    
    @organizer = organizer
    @account = organizer.marketplace
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com" 
    
    mailers = "#{organizer.email}"
    subject = "Sua carteira da Truppie foi atualizada com sucesso"
    
    @logo_file = "#{@organizer.to_param}.png"
    
    if @organizer.picture.present?
      if Rails.env.development?
        attachments[@logo_file] = @organizer.picture.url(:thumbnail)
      else
        attachments[@logo_file] = open(@organizer.picture.url(:thumbnail)).read
      end
    else
      begin
        attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
      rescue => e
        attachments[@logo_file] = nil
      end
    end
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    attachments['facebook_mail.png'] = File.read(Rails.root.join('app/assets/images/facebook_mail.png'))
    attachments['instagram_mail.png'] = File.read(Rails.root.join('app/assets/images/instagram_mail.png'))
    
    mail(
      subject: subject,
      to: mailers,
      bcc: copy_mailers,
      template_name: 'update',
      template_path: 'marketplace_mailer' 
     )
  end
  
  def activate_bank_account(organizer)
    
    @organizer = organizer
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com" 
    
    mailers = "#{organizer.email}"
    subject = "Sua conta bancária foi cadastrada na Truppie com sucesso"
    
    @logo_file = "#{@organizer.to_param}.png"
    
    if @organizer.picture.present?
      if Rails.env.development?
        attachments[@logo_file] = @organizer.picture.url(:thumbnail)
      else
        attachments[@logo_file] = open(@organizer.picture.url(:thumbnail)).read
      end
    else
      begin
        attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
      rescue => e
        attachments[@logo_file] = nil
      end
    end
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    attachments['facebook_mail.png'] = File.read(Rails.root.join('app/assets/images/facebook_mail.png'))
    attachments['instagram_mail.png'] = File.read(Rails.root.join('app/assets/images/instagram_mail.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: subject,
      to: mailers,
      bcc: copy_mailers,
      template_name: 'bank_account',
      template_path: 'marketplace_mailer' 
     )
  end
  
  def transfer(organizer, value, date)
    
    @organizer = organizer
    @transfer_value = value
    @transfer_date = date
    
    copy_mailers = "ola@truppie.com, alexanmtz@gmail.com, laurinha.sette@gmail.com" 
    
    mailers = "#{organizer.email}"
    subject = "Uma nova transferência para sua conta foi realizada"
    
    @logo_file = "#{@organizer.to_param}.png"
    
    if @organizer.picture.present?
      if Rails.env.development?
        attachments[@logo_file] = @organizer.picture.url(:thumbnail)
      else
        attachments[@logo_file] = open(@organizer.picture.url(:thumbnail)).read
      end
    else
      attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
    end
    
    attachments['logo-flat.png'] = File.read(Rails.root.join('app/assets/images/logo-flat.png'))
    attachments['facebook_mail.png'] = File.read(Rails.root.join('app/assets/images/facebook_mail.png'))
    attachments['instagram_mail.png'] = File.read(Rails.root.join('app/assets/images/instagram_mail.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: subject,
      to: mailers,
      bcc: copy_mailers,
      template_name: 'transfer',
      template_path: 'marketplace_mailer' 
     )
  end
  
end
