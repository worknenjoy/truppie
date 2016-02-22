require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  test "should get send" do
    post :create, :subscriber => {email: 'foo@example.com'}
    assert_response :success
  end
  
  test "should get send with any valid email" do
    post :create, :subscriber => {email: 'jonh@gmail.com'}
    assert_equal 'Subscriber was recorded', flash[:notice]  
  end
  
  test "should get send with empty email" do
    post :create, :subscriber => {email: ''}
      assert_equal "You should fill with your email", flash[:error]  
    end

end
