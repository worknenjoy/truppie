require 'test_helper'


class OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    sign_in users(:alexandre)
    @order = orders(:one)
    @payment = "ch_19qSuIBrSjgsps2DCXDNuqsD"
    @marketplace_stub_user_id = marketplaces(:marketplace_stub_user_id)

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
    
    @transfer_params = {
      "id": "evt_1A73vwHWrGpvLtXMMX1dJmTh",
      "object": "event",
      "api_version": "2017-01-27",
      "created": 1491836160,
      "data": {
        "object": {
          "id": "tr_1A73vvHWrGpvLtXM3xmc4LDB",
          "object": "transfer",
          "amount": 3290,
          "amount_reversed": 0,
          "application_fee": "null",
          "balance_transaction": "txn_1A73vvHWrGpvLtXMX21VAplk",
          "created": 1491836159,
          "currency": "brl",
          "date": 1491836159,
          "description": "null",
          "destination": "acct_1A38LlAV9HfXM8dB",
          "destination_payment": "py_1A73vvAV9HfXM8dBEbnCNUSk",
          "failure_code": "null",
          "failure_message": "null",
          "livemode": true,
          "metadata": {},
          "method": "standard",
          "recipient": "null",
          "reversals": {
            "object": "list",
            "data": [],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/transfers/tr_1A73vvHWrGpvLtXM3xmc4LDB/reversals"
          },
          "reversed": false,
          "source_transaction": "ch_payment222",
          "source_type": "card",
          "statement_descriptor": "null",
          "status": "paid",
          "transfer_group": "group_ch_1A73vtHWrGpvLtXMtlnovGAi",
          "type": "stripe_account"
        }
      },
      "livemode": true,
      "pending_webhooks": 1,
      "request": "req_ARxroCgpsUoRMN",
      "type": "transfer.created"
    }

    @transfer_done_params = {
        "id" => "evt_1ADs4UFJqvzNLRujpNsC81iI",
        "object"=>"event",
        "api_version"=>"2017-01-27",
        "created"=>1493458858,
        "data" => {
            "object" => {
              "id" => "po_1ADs4UFJqvzNLRuj6roovWYx",
              "object"=>"transfer",
              "amount"=>1880,
              "amount_reversed"=>0,
              "application_fee"=>nil,
              "balance_transaction"=>"txn_1ADs4UFJqvzNLRuj3YMkBNFp",
              "bank_account" =>
              {
                  "id"=>"ba_1A2RtgFJqvzNLRujrEiEaZGU",
                  "object"=>"bank_account",
                  "account_holder_name"=>"Laura Zerwes Amado Sette",
                  "account_holder_type"=>"individual",
                  "bank_name"=>"BANCO BRADESCO S.A.",
                  "country"=>"BR",
                  "currency"=>"brl",
                  "fingerprint"=>"MK7eWClTBE5ZllFf",
                  "last4"=>"5677",
                  "routing_number"=>"237-1432",
                  "status"=>"new"
              },
              "created"=>1493458858,
              "currency"=>"brl",
              "date"=>1493683200,
              "description"=>"STRIPE TRANSFER",
              "destination"=>"ba_1A2RtgFJqvzNLRujrEiEaZGU",
              "failure_code"=>nil,
              "failure_message"=>nil,
              "livemode"=>true,
              "metadata"=>{},
              "method"=>"standard",
              "recipient"=>nil,
              "reversals"=> {"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/transfers/po_1ADs4UFJqvzNLRuj6roovWYx/reversals"},
              "reversed"=>false,
              "source_transaction"=>nil,
              "source_type"=>"card",
              "statement_descriptor"=>nil,
              "status"=>"in_transit",
              "transfer_group"=>nil,
              "type"=>"bank_account"
            }
      },
      "livemode"=>true,
      "pending_webhooks"=>1,
      "request"=>nil,
      "type"=>"transfer.created",
      "user_id"=>"acct_1A2RYaFJqvzNLRuj"
    }
    @charge_params = {"id":"tr_1A73vvHWrGpvLtXM3xmc4LDB","object":"transfer","amount":3290,"amount_reversed":0,"application_fee":"null","balance_transaction":"txn_1A73vvHWrGpvLtXMX21VAplk","created":1491836159,"currency":"brl","date":1491836159,"description":"null","destination":"acct_1A38LlAV9HfXM8dB","destination_payment":"py_1A73vvAV9HfXM8dBEbnCNUSk","failure_code":"null","failure_message":"null","livemode":true,"metadata":{},"method":"standard","recipient":"null","reversals":{"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/transfers/tr_1A73vvHWrGpvLtXM3xmc4LDB/reversals"},"reversed":false,"source_transaction":"ch_1A73vtHWrGpvLtXMtlnovGAi","source_type":"card","statement_descriptor":"null","status":"paid","transfer_group":"group_ch_1A73vtHWrGpvLtXMtlnovGAi","type":"stripe_account"}

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
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :liquid => 180, :payment => @payment, :user => User.last, :tour => Tour.last)
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
  
  test "a new transfer should trigger a order approved by email if approved later" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => "ch_payment222", :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @transfer_params
    post :webhook, {}
    
    assert_equal assigns(:transfer), "ch_payment222"
    assert_equal assigns(:status), "succeeded"
    assert_equal assigns(:status_class), "alert-success"
    
    #transaction = transfer["source_transaction"]
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts ActionMailer::Base.deliveries[1].html_part

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries.length, 2 
    
  end
  
  test "a new charge should trigger destination payment" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => "ch_payment222", :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @transfer_params
    post :webhook, {}
    
    assert_equal assigns(:transfer), "ch_payment222"
    assert_equal assigns(:destination), "py_1A73vvAV9HfXM8dBEbnCNUSk"
    assert_equal assigns(:status), "succeeded"
    assert_equal assigns(:status_class), "alert-success"
    assert_equal Order.find(orders.id).destination, "py_1A73vvAV9HfXM8dBEbnCNUSk"
    
    #transaction = transfer["source_transaction"]
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries.length, 2 
    
  end
  
  test "a new transfer should trigger a order approved if approve payment on review" do
    orders = Order.create(:status => 'succeeded', :price => 200, :final_price => 200, :payment => "ch_1A73vtHWrGpvLtXMtlnovGAi", :user => User.last, :tour => Tour.last)
    @review_params = {
      "id": "evt_1A74DZHWrGpvLtXMOAjJ1go1",
      "object": "event",
      "api_version": "2017-01-27",
      "created": 1491837253,
      "data": {
        "object": {
          "id": "prv_1A73vvHWrGpvLtXMxF4pHcns",
          "object": "review",
          "charge": "ch_1A73vtHWrGpvLtXMtlnovGAi",
          "created": 1491836159,
          "livemode": true,
          "open": false,
          "reason": "approved"
        }
      },
      "livemode": true,
      "pending_webhooks": 1,
      "request": "req_ARy9tHfm1mjAHk",
      "type": "review.closed"
    }
    @request.env['RAW_POST_DATA'] = @review_params
    post :webhook, {}
    
    assert_equal assigns(:reviewed), "ch_1A73vtHWrGpvLtXMtlnovGAi"
    assert_equal assigns(:status), "succeeded"
    assert_equal assigns(:status_class), "alert-success"
    
    #transaction = transfer["source_transaction"]
    #puts ActionMailer::Base.deliveries[0].html_part
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries.length, 2 
    
  end

  test "should send a email when a succeeded transfer webhook is send to the organizer" do
    orders = Order.create(:price => 200, :final_price => 200, :payment => @payment, :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @transfer_done_params
    post :webhook, {}

    #puts ActionMailer::Base.deliveries[0].html_part
    #puts ActionMailer::Base.deliveries[1].html_part

    assert_equal assigns(:user_id), 'acct_1A2RYaFJqvzNLRuj'
    assert_equal assigns(:status), 'in_transit'
    assert_equal assigns(:type_of_action), 'transfer'
    assert_equal assigns(:transfer_status), 'in_transit'
    assert_equal assigns(:amount_to_transfer), 1880
    assert_equal assigns(:marketplace_organizer), @marketplace_stub_user_id
    assert_equal assigns(:marketplace_organizer_owner), "Laura Zerwes Amado Sette"
    assert_equal assigns(:marketplace_organizer_bankname), "BANCO BRADESCO S.A."
    assert_equal assigns(:marketplace_organizer_banknumber), "5677"


    assert_equal assigns(:status_class), "alert-success"
    assert_equal assigns(:subject), "Uma nova transferência a caminho"
    assert_equal assigns(:mail_first_line), "Uma nova transferência foi solicitada para Laura Zerwes Amado Sette"
    assert_equal assigns(:mail_second_line), "Uma transferência no valor de <strong><small>R$</small><span>18</span></strong> está em andamento para sua conta <br /> no banco BANCO BRADESCO S.A. de número ****5677 e avisaremos quando for concluída"

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries.length, 1

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
