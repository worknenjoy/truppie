require 'test_helper'


class OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    sign_in users(:alexandre)
    @order = orders(:one)
    @payment = "ch_19qSuIBrSjgsps2DCXDNuqsD"
    @post_params = {
      "id": "evt_19qSuHBrSjgsps2DD5DiwGT5",
      "object": "event",
      "created": 1487880581,
      "data": {
        "object": 
          {
            "id": "ch_19qSuIBrSjgsps2DCXDNuqsD",
            "object": "charge",
            "amount": 100,
            "amount_refunded": 0,
            "balance_transaction": "txn_19qSuIBrSjgsps2Dt2PoMOeB",
            "captured": true,
            "created": 1487880582,
            "currency": "usd",
            "description": "My First Test Charge (created for API docs)",
            "fraud_details": {},
            "livemode": false,
            "metadata": {},
            "outcome": {
              "network_status":"approved_by_network",
              "reason":"denied",
              "risk_level":"normal",
              "seller_message":"Payment complete.",
              "type":"authorized"
            },
            "paid": true,
            "refunded": false,
            "refunds": {
              "object": "list",
              "data": [],
              "has_more": false,
              "total_count": 0,
              "url": "/v1/charges/ch_19qSuIBrSjgsps2DCXDNuqsD/refunds"
            },
            "source": {
              "id": "card_19qSqOBrSjgsps2DxBs2TaNd",
              "object": "card",
              "brand": "Visa",
              "country": "US",
              "exp_month": 8,
              "exp_year": 2018,
              "funding": "credit",
              "last4": "4242",
              "metadata": {},
            },
            "status": "succeeded",
          }
      },
      "type": "charge.succeeded"
    }
    ActionMailer::Base.deliveries.clear
    
  end

  test "should get index" do
    skip('should authenticate')
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { discount: @order.discount, own_id: @order.own_id, price: @order.price, status: @order.status, tour_id: @order.tour_id, user_id: @order.user_id }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { discount: @order.discount, own_id: @order.own_id, price: @order.price, status: @order.status, tour_id: @order.tour_id, user_id: @order.user_id }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
  
  test "should not create a webhook without default parameter" do
    skip("migrate to stripe")
    get :new_webhook
    assert_equal 'voce precisa definir o tipo de webhook que voce ira enviar', flash[:error]
  end
  
  test "should create a default webhook" do
    skip("migrate to stripe")
    get :new_webhook, {:webhook_type => 'default'}
    
    assert_equal 'webhook padrao criado com sucesso', flash[:success]
    assert_not_nil assigns(:webhook_id)
  end
  
  test "should return success when post to webhook" do
    skip("migrate to stripe")
    post :webhook
    assert_response :success
  end
  
  test "should receive a post with successfull parameters and try to find succesfull this order" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => @payment, :user => User.last, :tour => Tour.last)
    
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    assert_equal assigns(:event), "charge.succeeded"
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts ActionMailer::Base.deliveries[0].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
  end
  
  test "should send the balance in each email confirmation send for the guide" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => @payment, :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    #puts ActionMailer::Base.deliveries[1].html_part
    assert_not ActionMailer::Base.deliveries.empty?
    #assert_equal ActionMailer::Base.deliveries[1].html_part.to_s.include?(tours(:morro).to_param), true
  end
  
  test "a new transfer should trigger a order approved on email" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => "ch_1A345fHWrGpvLtXMRsbSfDV4", :user => User.last, :tour => Tour.last)
    transfer = {
      "source_transaction": "ch_1A345fHWrGpvLtXMRsbSfDV4",
      "type":"stripe_account",
      "data": {
        "object": {
          "id": "an id",
           "status": "succeeded"
        }
        
      } 
    }
    @request.env['RAW_POST_DATA'] = transfer
    post :webhook, {}
    
    assert_equal assigns(:transfer), "ch_1A345fHWrGpvLtXMRsbSfDV4"
    #transaction = transfer["source_transaction"]
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries.length, 2 
    
  end
  
  test "when post to webhook and theres no orders found" do
    skip('handle cases where theres no order found')
    
    transfer = {"id":"tr_1A345iHWrGpvLtXMLjNvHALf","object":"transfer","amount":1880,"amount_reversed":0,"application_fee":null,"balance_transaction":"txn_1A345iHWrGpvLtXMNkWecVrI","created":1490883454,"currency":"brl","date":1490883454,"description":null,"destination":"acct_1A2RYaFJqvzNLRuj","destination_payment":"py_1A345iFJqvzNLRujUNpC6QG1","failure_code":null,"failure_message":null,"livemode":true,"metadata":{},"method":"standard","recipient":null,"reversals":{"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/transfers/tr_1A345iHWrGpvLtXMLjNvHALf/reversals"},"reversed":false,"source_transaction":"ch_1A345fHWrGpvLtXMRsbSfDV4","source_type":"card","statement_descriptor":null,"status":"paid","transfer_group":"group_ch_1A345fHWrGpvLtXMRsbSfDV4","type":"stripe_account"}
    @request.env['RAW_POST_DATA'] = transfer
    post :webhook, {}
    #transaction = transfer["source_transaction"]
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
    
  end
  
  test "should update status if doesnt have any" do
    orders = Order.create(:price => 200, :final_price => 200, :payment => @payment, :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    assert_equal Order.find(orders.id).status, 'succeeded'
    #puts ActionMailer::Base.deliveries[1].html_part
    assert_not ActionMailer::Base.deliveries.empty?
  end
  
  test "should not receive payment link when is authorized" do
    skip("migrate to stripe")
    
    order = Order.create(:status => 'PAYMENT.AUTHORIZED', :payment => @payment_boleto, :user => User.last, :tour => Tour.last, :payment_method => "BOLETO")
    
    @post_params_boleto[:event] = "PAYMENT.AUTHORIZED"
    @post_params_boleto[:resource][:payment][:status] = "AUTHORIZED"
    @request.env['RAW_POST_DATA'] = @post_params_boleto
    post :webhook, {}
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts ActionMailer::Base.deliveries[0].html_part
    order_link = "https://sandbox.moip.com.br/v2/payments/#{order.payment}"
    
    assert_not ActionMailer::Base.deliveries.empty?
    assert_not ActionMailer::Base.deliveries[0].html_part.to_s.index("boleto/PAY-55LJ77AT4JTN"), "should not have payment link"
  end
  
  test "should the user receive a email when payment is refunded" do
    skip("migrate to stripe")
    @request.env['RAW_POST_DATA'] = {"date":"","env":"","event":"PAYMENT.REFUNDED","resource":{"payment":{"_links":{"order":{"href":"https://sandbox.moip.com.br/v2/orders/ORD-4WHF2TSP3X4F","title":"ORD-4WHF2TSP3X4F"},"self":{"href":"https://sandbox.moip.com.br/v2/payments/PAY-ARVJHNTP3KQ6"}},"amount":{"currency":"BRL","fees":261,"liquid":3239,"refunds":0,"total":3500},"createdAt":"2016-04-13T00:46:24.000-03","delayCapture":false,"events":[{"createdAt":"2016-04-13T00:46:25.000-03","type":"PAYMENT.CREATED"},{"createdAt":"2016-04-13T00:46:08.494-03","type":"PAYMENT.REFUNDED"}],"fees":[{"amount":261,"type":"TRANSACTION"}],"fundingInstrument":{"creditCard":{"brand":"MASTERCARD","first6":"555566","holder":{"birthDate":"1982-10-06","birthdate":"1982-10-06","fullname":"Alexandre Magno Teles Zimerer","taxDocument":{"number":"05824493677","type":"CPF"}},"id":"CRC-PWZSLZSIXVC5","last4":"8884"},"method":"CREDIT_CARD"},"id":"PAY-4G6UKLVSNLXF","installmentCount":1,"status":"REFUNDED","updatedAt":"2016-04-13T00:46:08.494-03"}}}
    orders = Order.create(:status => 'PAYMENT.REFUNDED', :payment => "PAY-4G6UKLVSNLXF", :user => @order.user, :tour => @order.tour)
    post :webhook, {}
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries[0].to, [@order.user.email]
    #puts ActionMailer::Base.deliveries[0].html_part
    assert_equal ActionMailer::Base.deliveries.count, 2
    assert_equal ActionMailer::Base.deliveries[0].html_part.to_s.include?("Favor aguardar"), true
  end
  
  test "should receive a post with successfull parameters using a real returned object (email not receiving after a webhook from moip)" do
    skip("migrate to stripe")
    
    orders = Order.create(:status => 'PAYMENT.AUTHORIZED', :payment => @payment, :user => User.last, :tour => Tour.last)
    
    #puts orders.inspect 
    
    @request.env['RAW_POST_DATA'] = {"date":"","env":"","event":"PAYMENT.AUTHORIZED","resource":{"payment":{"_links":{"order":{"href":"https://sandbox.moip.com.br/v2/orders/ORD-4WHF2TSP3X4F","title":"ORD-4WHF2TSP3X4F"},"self":{"href":"https://sandbox.moip.com.br/v2/payments/PAY-ARVJHNTP3KQ6"}},"amount":{"currency":"BRL","fees":261,"liquid":3239,"refunds":0,"total":3500},"createdAt":"2016-04-13T00:46:24.000-03","delayCapture":false,"events":[{"createdAt":"2016-04-13T00:46:27.000-03","type":"PAYMENT.AUTHORIZED"},{"createdAt":"2016-04-13T00:46:25.000-03","type":"PAYMENT.CREATED"},{"createdAt":"2016-04-13T00:46:08.494-03","type":"PAYMENT.AUTHORIZED"}],"fees":[{"amount":261,"type":"TRANSACTION"}],"fundingInstrument":{"creditCard":{"brand":"MASTERCARD","first6":"555566","holder":{"birthDate":"1982-10-06","birthdate":"1982-10-06","fullname":"Alexandre Magno Teles Zimerer","taxDocument":{"number":"05824493677","type":"CPF"}},"id":"CRC-PWZSLZSIXVC5","last4":"8884"},"method":"CREDIT_CARD"},"id":"PAY-32LJ77AT4JNN","installmentCount":1,"status":"AUTHORIZED","updatedAt":"2016-04-13T00:46:08.494-03"}}}
    post :webhook, {}
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts '--- corpo do email enviado ----'
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts '-------------------------------'
    
    assert_not ActionMailer::Base.deliveries.empty?
  
  end
  
  test "should receive a post with successfull parameters using the live website(production testing)" do
    skip("migrate to stripe")
    
    #orders = Order.create(:status => 'IN_ANALYSIS', :payment => @payment, :user => User.last, :tour => Tour.last)
    
    #puts orders.inspect 
    
    @request.env['RAW_POST_DATA'] = {"date":"","env":"","event":"PAYMENT.AUTHORIZED","resource":{"payment":{"_links":{"order":{"href":"https://sandbox.moip.com.br/v2/orders/ORD-4WHF2TSP3X4F","title":"ORD-4WHF2TSP3X4F"},"self":{"href":"https://sandbox.moip.com.br/v2/payments/PAY-ARVJHNTP3KQ6"}},"amount":{"currency":"BRL","fees":261,"liquid":3239,"refunds":0,"total":3500},"createdAt":"2016-04-13T00:46:24.000-03","delayCapture":false,"events":[{"createdAt":"2016-04-13T00:46:27.000-03","type":"PAYMENT.AUTHORIZED"},{"createdAt":"2016-04-13T00:46:25.000-03","type":"PAYMENT.CREATED"},{"createdAt":"2016-04-13T00:46:08.494-03","type":"PAYMENT.AUTHORIZED"}],"fees":[{"amount":261,"type":"TRANSACTION"}],"fundingInstrument":{"creditCard":{"brand":"MASTERCARD","first6":"555566","holder":{"birthDate":"1982-10-06","birthdate":"1982-10-06","fullname":"Alexandre Magno Teles Zimerer","taxDocument":{"number":"05824493677","type":"CPF"}},"id":"CRC-PWZSLZSIXVC5","last4":"8884"},"method":"CREDIT_CARD"},"id":"PAY-4G6UKLVSNLXF","installmentCount":1,"status":"AUTHORIZED","updatedAt":"2016-04-13T00:46:08.494-03"}}}
    
    #response = RestClient.post "http://www.truppie.com/webhook", @request 
    #puts '--------------'
    #puts response.inspect
    #puts '--------------'
    #assert_not_nil assigns(:event)
    #assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts '--- corpo do email enviado do retorno de producao ----'
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts '-------------------------------'
    
    #assert_not ActionMailer::Base.deliveries.empty?
  
  end
  
  test "should create a status history" do
    skip("migrate to stripe")
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    #puts ActionMailer::Base.deliveries[0].html_part
    
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_equal ["PAYMENT.AUTHORIZED"], Order.find(@order.id).status_history 
  end
  
  test "should not send notification if the current status already exist" do
    skip("migrate to stripe")
    @order.update_attributes(:status_history => ["PAYMENT.AUTHORIZED"])
    
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    assert ActionMailer::Base.deliveries.empty?
  end
  
  test "should make a post from live website" do
    skip("a post to webhook live")
    response = RestClient.post "http://www.truppie.com/webhook/", {}
    #puts response.inspect
    #puts '-----------'
    #puts response.code
    #puts '-----------'
    assert_response :success
  end
  
  
end
