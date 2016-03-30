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
     assert_equal ['no-reply@truppie.com'], mail.from
     assert_equal ["ola@truppie.com", "laurinha@email.com", "joana@email.com"], mail.to
     assert_equal "O seu pagamento se encontra em análise pela operadora do cartão", mail.body.raw_source
  end
end
