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
    tour_to_order = tours(:morro)
    order = tour_to_order.orders.create(
        :status => 'succeeded',
        :price => 1000,
        :status_history => ['succeeded'],
        :final_price => 1000,
        :payment => 'paymentid',
        :user => User.last,
        :tour => tour_to_order,
        :liquid => 800 
      )
    
     @status = {
        subject: "O seu pagamento se encontra em análise pela operadora do cartão",
        content: "em análise",
        guide: 'status_change_guide_authorized',
        status_class: "alert-success"
     }
     
     mail = CreditCardStatusMailer.guide_mail(@status, order, User.take, tour_to_order, tour_to_order.organizer)
     
     CreditCardStatusMailer.guide_mail(@status, order, User.first, tour_to_order, tour_to_order.organizer).deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["organizer@mail.com"], mail.to
     assert_equal "Notificação enviada ao usuário da sua truppie - O seu pagamento se encontra em análise pela operadora do cartão", mail.subject
  end
  
end
