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
     auth = Moip2::Auth::Basic.new(Rails.application.secrets[:moip_token], Rails.application.secrets[:moip_key])
     client = Moip2::Client.new(:sandbox, auth)
     api = Moip2::Api.new(client)
     order = api.order.create(
          {
              own_id: "ruby_sdk_1",
              items: [
                {
                  product: "Nome do produto",
                  quantity: 1,
                  detail: "Mais info...",
                  price: 1000
                }
              ],
              customer: {
                own_id: "ruby_sdk_customer_1",
                fullname: "Jose da Silva",
                email: "sandbox_v2_1401147277@email.com",
              }
          }
      )
     payment = api.payment.create(order.id,
          {
              installment_count: 1,
              funding_instrument: {
                  method: "CREDIT_CARD",
                  credit_card: {
                      expiration_month: 04,
                      expiration_year: 18,
                      number: "4012001038443335",
                      cvc: "123",
                      holder: {
                          fullname: "Jose Portador da Silva",
                          birthdate: "1988-10-10",
                          tax_document: {
                              type: "CPF",
                              number: "22222222222"
                      },
                          phone: {
                              country_code: "55",
                              area_code: "11",
                              number: "55667788"
                          }
                      }
                  }
              }
          }
      )
      #puts payment.inspect
      order = tour_to_order.orders.create(
        :status => 'PAYMENT.AUTHORIZED',
        :price => 1000,
        :status_history => ['PAYMENT.WAITING','PAYMENT.AUTHORIZED'],
        :final_price => 1000,
        :payment => payment[:id],
        :user => User.last,
        :tour => tour_to_order
      )
    
     @status = {
        subject: "O seu pagamento se encontra em análise pela operadora do cartão",
        content: "em análise",
        guide: 'status_change_guide_authorized',
        status_class: "alert-error"
     }
     
     mail = CreditCardStatusMailer.guide_mail(@status, order, User.take, tour_to_order, tour_to_order.organizer)
     
     CreditCardStatusMailer.guide_mail(@status, order, User.first, tour_to_order, tour_to_order.organizer).deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["organizer@mail.com"], mail.to
     assert_equal "Notificação enviada ao usuário da sua truppie - O seu pagamento se encontra em análise pela operadora do cartão", mail.subject
  end
  
end
