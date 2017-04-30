# Preview all emails at http://localhost:3000/rails/mailers/transfer_mailer
class TransferMailerPreview < ActionMailer::Preview

  def transfered
    @status_class = "alert-success"
    @subject = "Uma nova transferência foi realizada"
    @mail_first_line = "Uma nova transferência foi solicitada"
    @mail_second_line = "Uma transferência no valor de <strong>1880</strong> foi realizada para sua conta"

    @status_data = {
        subject: @subject,
        mail_first_line: @mail_first_line,
        mail_second_line: @mail_second_line,
        status_class: @status_class
    }
    TransferMailer.transfered(Organizer.last, @status_data)
  end

end
