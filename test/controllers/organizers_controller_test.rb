 include Devise::TestHelpers
 require 'test_helper'
 
 class OrganizersControllerTest < ActionController::TestCase
   self.use_transactional_fixtures = true
   setup do
     sign_in users(:alexandre)
     @organizer_ready = organizers(:utopicos)
     @mkt = organizers(:mkt)
     
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
   
   test "should admin organizer" do
     get :manage, id: @organizer_ready.id
     assert_response :success
   end
   
   test "should not admin organizer if is not the organizer owner and no admin" do
     sign_out users(:alexandre)
     sign_in users(:fulano)
     get :manage, id: @organizer_ready.id
     assert_equal flash[:notice], "Você não está autorizado a entrar nesta página"
     assert_redirected_to new_user_session_path
   end
   
   test "should admin organizer if is the organizer owner" do
     sign_out users(:alexandre)
     sign_in users(:joana)
     get :manage, id: @organizer_ready.id
     assert_response :success
   end
   
   test "should direct organizer to marketplace register" do
     get :marketplace, id: @organizer_ready.id
     assert_response :success
   end
   
   test "should go to transfer page" do
     body = [{"current" => 0, "future" => 0}]
     FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/balances", :body => body.to_json, :status => ["201", "Created"])
     FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/transfers", :body => "{}", :status => ["200", "Success"])
     get :transfer, id: @mkt.id
     assert assigns(:money_account_json), [{"bankNumber"=>"MyString", "agencyNumber"=>"MyString", "accountNumber"=>"MyString", "agencyCheckNumber"=>"MyString", "accountCheckNumber"=>"MyString", "type"=>"MyString", "holder"=>{"taxDocument"=>{"type"=>"MyString", "number"=>"MyString"}, "fullname"=>"MyString"}}]
     assert assigns(:transfer_json), {}
     assert_response :success
   end
   
   
   
 end
