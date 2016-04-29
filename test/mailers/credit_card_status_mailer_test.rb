require 'test_helper'

class CreditCardStatusMailerTest < ActionMailer::TestCase
  test "Sending a changing status from the webhook" do
     @status = {
        subject: "O seu pagamento se encontra em análise pela operadora do cartão",
        content: "em análise"
     }
     
     mail = CreditCardStatusMailer.status_change(@status, Order.last, User.take, Tour.last, Organizer.last)
     
     CreditCardStatusMailer.status_change(@status, Order.last, User.first, Tour.last, Organizer.last).deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["laurinha.sette@gmail.com"], mail.to
     assert_equal "O seu pagamento se encontra em análise pela operadora do cartão", mail.subject
  end
  
  test "Sending a changing status to organizer" do
     @status = {
        subject: "O seu pagamento se encontra em análise pela operadora do cartão",
        content: "em análise",
        guide: 'status_change_guide_authorized'
     }
     
     mail = CreditCardStatusMailer.guide_mail(@status, Order.last, User.take, Tour.last, Organizer.last)
     
     CreditCardStatusMailer.guide_mail(@status, Order.last, User.first, Tour.last, Organizer.last).deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["organizer@mail.com"], mail.to
     assert_equal "Notificação enviada ao usuário da sua truppie - O seu pagamento se encontra em análise pela operadora do cartão", mail.subject
  end
  
end
