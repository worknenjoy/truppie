# Preview all emails at http://localhost:3000/rails/mailers/credit_card_status_mailer
class CreditCardStatusMailerPreview < ActionMailer::Preview
  def user_order
     @status_data = {
      subject: "Seu pagamento foi aprovado",
      mail_first_line: "O seu pagamento foi aprovado",
      mail_second_line: "Aprovamos seu pagamento",
      guide: "template_guide",
      status_class: "alert-danger"
    }
    CreditCardStatusMailer.status_change(@status_data, Order.last, User.take, Tour.last, Organizer.last)
  end
  
  def guide_order
     @status_data = {
      subject: "Seu pagamento foi aprovado",
      mail_first_line: "O seu pagamento foi aprovado",
      mail_second_line: "Aprovamos seu pagamento",
      guide: "status_change_guide_authorized"
    }
    CreditCardStatusMailer.guide_mail(@status_data, Order.last, User.take, Tour.last, Organizer.last)
  end
  
  
end
