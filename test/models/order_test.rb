require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  test "getting the status of a order" do
    assert true
  end
  
  test "one tour created" do
    assert_equal 4, Order.count
  end
   
  test "order return boleto payment" do
    assert_equal orders(:bol).payment_method, "BOLETO" 
  end
   
  test "order return boleto payment link" do 
    order = orders(:bol)
    assert_equal order.payment_link, "https://checkout.moip.com.br/boleto/#{order.payment}"
  end
  
  test "get a payment fee and liquid value" do
    skip("get a mocked call to payment")
    
  end
  
  test "get a real payment and get the tax" do
    #skip("real payment call")
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
      order = Order.create(
        :status => 'PAYMENT.AUTHORIZED',
        :price => 1000,
        :status_history => ['PAYMENT.WAITING','PAYMENT.AUTHORIZED'],
        :final_price => 1000,
        :payment => payment[:id],
        :user => User.last,
        :tour => Tour.last
      )
      #puts order.inspect
      assert_equal payment[:events][1][:type], "PAYMENT.CREATED"
      assert_equal payment[:amount][:fees], 0
      assert_equal payment[:fees][0].to_h, {:type=>"TRANSACTION", :amount=>0}
      fees = order.fees
      assert_equal fees, {:fee=>124, :liquid=>876, :total=>1000}
  end
  
  
end
