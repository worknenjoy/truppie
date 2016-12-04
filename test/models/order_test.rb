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
end
