require 'test_helper'
include Devise::TestHelpers

class OrdersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @order = orders(:one)
    @order_boleto = orders(:bol)
    @payment = "PAY-32LJ77AT4JNN"
    @payment_boleto = "PAY-55LJ77AT4JTN"
    @post_params = {
      "event": "PAYMENT.AUTHORIZED",
      "resource": {
        "payment": {
          "id": @payment,
          "status": "AUTHORIZED",
          "installmentCount": 1,
          "amount": {
            "total": 2000,
            "liquid": 1813,
            "refunds": 0,
            "fees": 187,
            "currency": "BRL"
          },
          "fundingInstrument": {
            "method": "CREDIT_CARD",
            "creditCard": {
              "id": "CRC-BXXOA5RLGQR8",
              "holder": {
                "taxDocument": {
                  "number": "33333333333",
                  "type": "CPF"
                },
                "birthdate": "30/12/1988",
                "fullname": "Jose Portador da Silva"
              },
              "brand": "MASTERCARD",
              "first6": "555566",
              "last4": "8884"
            }
          },
          "events": [
            {
              "createdAt": "2015-03-16T18:11:19-0300",
              "type": "PAYMENT.AUTHORIZED"
            },
            {
              "createdAt": "2015-03-16T18:11:16-0300",
              "type": "PAYMENT.CREATED"
            }
          ],
          "fees": [
            {
              "amount": 187,
              "type": "TRANSACTION"
            }
          ],
          "createdAt": "2015-03-16T18:11:16-0300",
          "updatedAt": "2015-03-16T18:11:19-0300",
          "_links": {
            "order": {
              "title": "ORD-SDZARE29MWVY",
              "href": "https://sandbox.moip.com.br/v2/orders/ORD-SDZARE29MWVY"
            },
            "self": {
              "href": "https://sandbox.moip.com.br/v2/payments/PAY-32LJ77AT4JNN"
            }
          }
        }
      }
    }
    
    @post_params_boleto = {
      "event": "PAYMENT.WAITING",
      "resource": {
        "payment": {
          "id": @payment_boleto,
          "status": "WAITING",
          "installmentCount": 1,
          "amount": {
            "total": 2000,
            "liquid": 1813,
            "refunds": 0,
            "fees": 187,
            "currency": "BRL"
          },
          "fundingInstrument": {
            "method": "BOLETO",
            "BOLETO": {
              "expirationDate": "2077-09-30",
              "instructionLines": {
                "first": "Primeira linha se instrução",
                "second": "Segunda linha se instrução",
                "third": "Terceira linha se instrução"
              },
            }
          },
          "events": [
            {
              "createdAt": "2015-03-16T18:11:19-0300",
              "type": "PAYMENT.AUTHORIZED"
            },
            {
              "createdAt": "2015-03-16T18:11:16-0300",
              "type": "PAYMENT.CREATED"
            }
          ],
          "fees": [
            {
              "amount": 187,
              "type": "TRANSACTION"
            }
          ],
          "createdAt": "2015-03-16T18:11:16-0300",
          "updatedAt": "2015-03-16T18:11:19-0300",
          "_links": {
            "order": {
              "title": "ORD-SDZARE29MWVY",
              "href": "https://sandbox.moip.com.br/v2/orders/ORD-SDZARE29MWVY"
            },
            "self": {
              "href": "https://sandbox.moip.com.br/v2/payments/PAY-32LJ77AT4JNN"
            }
          }
        }
      }
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
    get :new_webhook
    assert_equal 'voce precisa definir o tipo de webhook que voce ira enviar', flash[:error]
  end
  
  test "should create a default webhook" do
    get :new_webhook, {:webhook_type => 'default'}
    
    assert_equal 'webhook padrao criado com sucesso', flash[:success]
    assert_not_nil assigns(:webhook_id)
  end
  
  test "should return success when post to webhook" do
    post :webhook
    assert_response :success
  end
  
  test "should receive a post with successfull parameters from moip and try to find succesfull this order" do
    #skip("successfull post")
    
    orders = Order.create(:status => 'PAYMENT.AUTHORIZED', :payment => @payment, :user => User.last, :tour => Tour.last)
    
    #puts orders.inspect 
    
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts ActionMailer::Base.deliveries[0].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
  end
  
  test "should send the balance in each email confirmation send for the guide" do
    orders = Order.create(:status => 'PAYMENT.AUTHORIZED', :payment => @payment, :user => User.last, :tour => Tour.last)
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    #puts ActionMailer::Base.deliveries[1].html_part
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ActionMailer::Base.deliveries[1].html_part.to_s.include?("http://localhost:3000/organizers/1041462269"), true
    assert_equal ActionMailer::Base.deliveries[1].html_part.to_s.include?(tours(:morro).to_param), true
  end
  
  test "should receive a post with successfull parameters from moip when is boleto" do
    #skip("successfull post")
    order = Order.create(:status => 'PAYMENT.WAITING', :payment => @payment_boleto, :user => User.last, :tour => Tour.last, :payment_method => "BOLETO")
    
    #puts orders.inspect 
    
    @request.env['RAW_POST_DATA'] = @post_params_boleto
    post :webhook, {}
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    #puts ActionMailer::Base.deliveries[0].html_part
    order_link = "https://sandbox.moip.com.br/v2/payments/#{order.payment}"
    
    assert_not ActionMailer::Base.deliveries.empty?
    assert ActionMailer::Base.deliveries[0].html_part.to_s.index("boleto/PAY-55LJ77AT4JTN"), "should have payment link"
  end
  
  test "should not receive payment link when is authorized" do
    #skip("successfull post")
    
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
  
  test "should receive a post with successfull parameters using a real returned object (email not receiving after a webhook from moip)" do
    #skip("successfull post")
    
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
    skip("successfull post to production")
    
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
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    #puts ActionMailer::Base.deliveries[0].html_part
    
    #puts ActionMailer::Base.deliveries[1].html_part
    
    assert_equal ["PAYMENT.AUTHORIZED"], Order.find(@order.id).status_history 
  end
  
  test "should not send notification if the current status already exist" do
    #skip('no send notifications if is in current_status')
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
