require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  test "should get send" do
    post :create, :subscriber => {email: 'foo@example.com'}
    assert_equal Subscriber.last.email, 'foo@example.com'
    assert_redirected_to root_path + '#warning'
  end
  
  test "should get send with any valid email" do
    post :create, :subscriber => {email: 'jonh@gmail.com'}
    assert_equal 'Você foi inscrito com sucesso, aguarde as novidades', flash[:success]  
  end
  
  test "should get send with empty email" do
    post :create, :subscriber => {email: ''}
    assert_equal "não pode ficar em branco", flash[:error]  
  end
  
  test "not a valid email" do 
    post :create, :subscriber => {email: 'notvalid'}
    assert_equal "Não é um e-mail válido", flash[:error]
  end
  
end
