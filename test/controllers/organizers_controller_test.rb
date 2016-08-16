 include Devise::TestHelpers
 require 'test_helper'
 
 class OrganizersControllerTest < ActionController::TestCase
   self.use_transactional_fixtures = true
   setup do
     sign_in users(:alexandre)
     @organizer_ready = organizers(:utopicos)
     @organizer_with_account = organizers(:utopicos_marketplace)
     
     @organizer = {
       name: "Utópicos mundo afora",
       description: "uma agencia utopica",
       email: "utopicos@gmail.com",
       website: "http://website",
       facebook: "a facebook",
       twitter: "a twitter",
       instagram: "a instagram",
       phone: "a phone",
       user_id: users(:alexandre).id
     }
     
   end
   
   test "should test signin success by admin" do
    @controller.send(:check_if_admin)
     
    assert_response :success 
   end
   
   test "should test signin error" do
    sign_in users(:ciclano)
   
    get :index
    assert_redirected_to root_url 
   end
   
   test "should test signin of organizer owner" do
    
    sign_in users(:joana)
    
    get :dashboard, id: @organizer_ready.id
    assert_response :success
   end
# 
   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:organizers)
   end
# 
   test "should get new" do
     get :new
     assert_response :success
   end
# 
   test "should create organizer" do
     assert_difference('Organizer.count') do
       post :create, organizer: @organizer
     end
# 
     assert_redirected_to organizer_path(assigns(:organizer))
   end
# 
   test "should show organizer" do
     get :show, id: @organizer_ready.id
     assert_response :success
   end
# 
   test "should get edit" do
     get :edit, id: @organizer_ready.id
     assert_response :success
   end
# 
   test "should update organizer" do
     patch :update, id: @organizer_ready.id, organizer: @organizer 
     assert_redirected_to organizer_path(assigns(:organizer))
   end
   
   test "should update with account bank info active" do
     skip("update account")
     patch :update, id: @organizer_with_account.id, organizer: @organizer_with_account.attributes
     
     #puts @organizer_with_account.inspect
     
     assert_equal @organizer_with_account.active, false
       
     assert_redirected_to organizer_path(assigns(:organizer))
   end
   
   test "should create new account with name" do
     skip("new account with name")
     patch :update, id: @organizer_with_account.id, organizer: @organizer_with_account.attributes
     
     #puts @organizer_with_account.inspect
     
     assert_equal @organizer_with_account.person_name, "Joao Cabral"
     assert_redirected_to @organizer_with_account
     
   end
   
   test "activating a organizer as a account bank with no data filled" do
     skip("activating organizer no data filled")
     post :account_activate, id: @organizer_ready.id, organizer: @organizer_ready.attributes
     
     #puts @organizer_ready.inspect
     
     assert_equal Organizer.find(@organizer_ready.id).active, false
     assert_redirected_to @organizer_ready
     assert_equal "É necessário preencher todos os dados do titular da conta", flash[:notice]      
   end
   
   test "activating a organizer as a account bank with full data filled" do
     skip("activate organizer full data filled")
     post :account_activate, id: @organizer_with_account.id, organizer: @organizer_with_account.attributes
     
     #puts @organizer_ready.inspect
     
     #assert_equal Organizer.find(@organizer_with_account.id).active, true
     
     #assert_redirected_to @organizer_with_account
     assert_not_nil Organizer.find(@organizer_with_account.id).token
     assert_not_nil Organizer.find(@organizer_with_account.id).account_id
     assert_equal Organizer.find(@organizer_with_account.id).active, true
     assert_equal "Conta ativada", flash[:notice]
   end
   
   test "transfer funds to organizer account no money" do
     skip("transfer funds")
     post :account_activate, id: @organizer_with_account.id, organizer: @organizer_with_account.attributes
     post :transfer_funds, id: @organizer_with_account, amount: 2000
     assert assigns(:amount) == "2000", "the amount is passed #{assigns(:amount)}"
     assert assigns(:organizer) == @organizer_with_account, "the organizer is #{@organizer_with_account.name}"
     assert assigns(:bank_account)["accountNumber"] == "12345678", "response transfer is #{assigns(:bank_account).inspect}"
     #assert assigns(:response_transfer)["amount"] == 2000, "response transfer is #{assigns(:response_transfer)}"
     #assert assigns(:response_transfer)["status"] == "REQUESTED", "response transfer is #{assigns(:response_transfer)}"
     assert_equal "Não foi possível realizar a transferência", flash[:notice]
   end
   
   test "deleting all acounts" do
     headers = {
        :content_type => 'application/json',
        :authorization => 'OAuth 65a0331eba0e4f11b8f738a313d6369e_v2'
      }
     
     response = RestClient.get "https://sandbox.moip.com.br/v2/accounts/MPA-DFA0B327F85C/bankaccounts", headers
     
     response_json = JSON.load response
     
     #puts response_json.inspect
     
     response_json.each do |b|
       RestClient.delete "https://sandbox.moip.com.br/v2/bankaccounts/#{b["id"]}", headers
     end
     
   end
   
   
# 
 end
