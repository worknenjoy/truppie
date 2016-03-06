require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  test "should get send" do
    post :create, :subscriber => {email: 'foo@example.com'}
    assert_equal Subscriber.last.email, 'foo@example.com'
    assert_redirected_to root_path + '#warning'
  end
  
  test "should get send with any valid email" do
    post :create, :subscriber => {email: 'jonh@gmail.com'}
    assert_equal 'Subscriber was recorded', flash[:success]  
  end
  
  test "should get send with empty email" do
    post :create, :subscriber => {email: ''}
    assert_equal "can't be blank", flash[:error]  
  end
  
  test "not a valid email" do 
    post :create, :subscriber => {email: 'notvalid'}
    assert_equal "is not an email", flash[:error]
  end
  
end
