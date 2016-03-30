require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
    @payment = "PAY-32LJ77AT4JNN"
    @post_params = {
      "event": "PAYMENT.IN_ANALYSIS",
      "resource": {
        "payment": {
          "id": @payment,
          "status": "IN_ANALYSIS",
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
              "type": "PAYMENT.IN_ANALYSIS"
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
    
    orders = Order.create(:status => 'IN_ANALYSIS', :payment => @payment, :user => User.last, :tour => Tour.last)
    
    #puts orders.inspect 
    
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    assert_not_nil assigns(:status_data)
    assert_response :success
    
    puts ActionMailer::Base.deliveries[0].html_part
    
    assert_not ActionMailer::Base.deliveries.empty?
    
  end
  
  test "should create a status history" do
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    puts ActionMailer::Base.deliveries[0].html_part
    
    puts ActionMailer::Base.deliveries[1].html_part
    
    assert_equal ["PAYMENT.IN_ANALYSIS"], Order.find(@order.id).status_history 
  end
  
  test "should not send notification if the current status already exist" do
    #skip('no send notifications if is in current_status')
    @order.update_attributes(:status_history => ["PAYMENT.IN_ANALYSIS"])
    
    @request.env['RAW_POST_DATA'] = @post_params
    post :webhook, {}
    
    assert ActionMailer::Base.deliveries.empty?
  end
  
  test "should make a post from live website" do
    skip("a post to webhook live")
    response = RestClient.post "http://www.truppie.com/webhook/", {}
    puts response.inspect
    puts '-----------'
    puts response.code
    puts '-----------'
    assert_response :success
  end
  
  
end
