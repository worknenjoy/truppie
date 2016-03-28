require 'test_helper'

class CreditCardStatusMailerTest < ActionMailer::TestCase
  test "Sending a changing status from the webhook" do
     params = {from: 'ola@truppie.com', subject: 'cartao de credito', body: "status do cartao alterado", to: 'user@gmail.com'}
     mail = CreditCardStatusMailer.status_change("232323")
     
     CreditCardStatusMailer.status_change('params').deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ['alexanmtz@gmail.com'], mail.to
     assert_equal "status do cartao alterado", mail.body.raw_source
  end
end
