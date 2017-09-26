class OrganizerMailer < ApplicationMailer
  layout 'base_mail'
  
  def notify(organizer, status)
    
    @organizer = organizer
    @status = status
    
    case @status
      when "activate"
        @status_to_user = "criada"
      when "update"
        @status_to_user = "atualizada"
      else
        @status_to_user = "atualizada"
    end
    
    @copy_mailers = "ola@truppie.com,#{Rails.application.secrets[:admin_email]},#{Rails.application.secrets[:admin_email_alt]}"
    mailers = "#{organizer.email}"
    subject = "Olá #{organizer.name}, sua conta na Truppie foi #{@status_to_user}!"
    
    #@logo_file = "#{@organizer.to_param}.png"
    
    #if @organizer.picture.present?
    #  if Rails.env.development?
    #    attachments[@logo_file] = @organizer.picture.url(:thumbnail)
    #  else
    #    attachments[@logo_file] = open(@organizer.picture.url(:thumbnail)).read
    #  end
    #else
    #  begin
    #    attachments[@logo_file] = File.read("app/assets/images/#{@organizer.logo}")
    #  rescue => e
    #    attachments[@logo_file] = nil
    #  end
    #end
    
    attachments['logo-transparent.png'] = File.read(Rails.root.join('app/assets/images/logo-transparent.png'))
    
    attachments['organizer-welcome.png'] = File.read(Rails.root.join('app/assets/images/organizer-welcome.jpg'))
    attachments['facebook_mail.png'] = File.read(Rails.root.join('app/assets/images/facebook_mail.png'))
    attachments['instagram_mail.png'] = File.read(Rails.root.join('app/assets/images/instagram_mail.png'))
    
    mail(
      from: 'ola@truppie.com',
      subject: subject,
      to: mailers,
      bcc: @copy_mailers,
      template_name: 'notify',
      template_path: 'organizer_mailer' 
     )
  end
end
