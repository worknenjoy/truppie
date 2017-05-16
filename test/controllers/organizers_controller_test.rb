 include Devise::TestHelpers
 require 'test_helper'
 
 class OrganizersControllerTest < ActionController::TestCase
   self.use_transactional_fixtures = true
   
   setup do
     StripeMock.start
     sign_in users(:alexandre)
     @organizer_ready = organizers(:utopicos)
     @mkt = organizers(:mkt)
     @guide_mkt_validated = organizers(:guide_mkt_validated)
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
   
   teardown do
    StripeMock.stop
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
     assert_not ActionMailer::Base.deliveries.empty?
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
     #assert_not ActionMailer::Base.deliveries.empty?
     assert_redirected_to organizer_path(assigns(:organizer))
   end
   
   test "should admin organizer" do
     get :manage, id: @organizer_ready.id
     assert_response :success
   end

   test "should open panel" do
     get :dashboard, id: @organizer_ready.id
     assert_response :success
   end

   test "should open new tour for the organizer" do
     get :guided_tour, id: @organizer_ready.id

     assert_not_nil assigns(:guided_tour), @organizer_ready.tours.new
     assert_response :success
   end

   test "should display the edit form" do
     post :edit_guided_tour, {id: @organizer_ready.id, tour: @organizer_ready.tours.first}
     assert_equal assigns(:should_hide_form), false
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
   
   test "should load the terms in the page" do
     get :tos_acceptance, id: @organizer_ready.id
     assert_response :success 
   end
   
   test "should create policies" do
     @organizer["policy"] = "almoco;jantar;cafe"
     
     assert_difference('Organizer.count') do
      post :create, organizer: @organizer
     end
     
     assert_equal Organizer.last.policy[0], "almoco"
     assert_equal Organizer.last.policy[1], "jantar"
     assert_equal Organizer.last.policy[2], "cafe"
   end
   
   test "should create with no members" do
     @organizer["members"] = ""
     
     assert_difference('Organizer.count') do
      post :create, organizer: @organizer
     end
     
     assert_equal Organizer.last.members, []
   end
   
   test "should create policies empty" do
     @organizer["policy"] = ""
     
     assert_difference('Organizer.count') do
      post :create, organizer: @organizer
     end
     
     assert_equal Organizer.last.policy, []
   end
   
   test "should not accept the terms of a not registered guide on marketplace" do
     post :tos_acceptance_confirm, id: @organizer_ready.id, ip: '100.22.10.1', date_of_acceptance: "2014-12-01T01:29:18".to_date
     assert_equal assigns(:ip), "100.22.10.1"
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:status_message), "Você ainda não está cadastrado no Marketplace de guias"
     assert_response :success 
   end
   
   test "should accept the terms in the page" do
     account = @guide_mkt_validated.marketplace.activate
     assert_equal account.id.include?('acct_'), true
     
     post :tos_acceptance_confirm, id: @guide_mkt_validated, ip: '100.22.10.1'
     assert_equal assigns(:ip), "100.22.10.1"
     assert_equal assigns(:status_message), "Seus termos foram aceitos com sucesso" 
     assert_equal assigns(:status), "success"
     assert_response :success 
   end
   
   test "should go to transfer page with no transference" do
     skip("refactor to stripe")
     body = [{"current" => 0, "future" => 0}]
     FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/balances", :body => body.to_json, :status => ["201", "Created"])
     FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/transfers", :body => "{}", :status => ["200", "Success"])
     get :transfer, id: @mkt.id
     assert assigns(:money_account_json), [{"bankNumber"=>"MyString", "agencyNumber"=>"MyString", "accountNumber"=>"MyString", "agencyCheckNumber"=>"MyString", "accountCheckNumber"=>"MyString", "type"=>"MyString", "holder"=>{"taxDocument"=>{"type"=>"MyString", "number"=>"MyString"}, "fullname"=>"MyString"}}]
     assert assigns(:transfer_json), {}
     assert_response :success
   end
   
   test "should not transfer amount to organizer if there's no active bank account" do
     post :transfer_funds, id: @mkt.id, amount: 200, current: 300
     assert_nil assigns(:bank_account_active_id)
     assert_equal assigns(:amount), 20000
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:message_status), "Você não tem nenhuma conta bancária ativa no momento"
     assert_response :success
   end
   
   test "should not transfer if there's no enough money" do
     @mkt.marketplace.bank_account_active.update_attributes(:own_id => "fooid")
     post :transfer_funds, id: @mkt.id, amount: 200, current: 100
     assert_equal assigns(:bank_account_active_id), "fooid"
     assert_equal assigns(:amount), 20000
     assert_equal assigns(:current), 10000
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:message_status), "Você não tem fundos suficientes para realizar esta transferência"
     assert_response :success
   end
   
   test "should not transfer without amount" do
     post :transfer_funds, id: @mkt.id
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:message_status), "Você não especificou um valor"
     assert_response :success
   end
   
   test "should load successfully the organizer manage" do
     get :manage, id: @mkt.id
     assert_response :success
   end
   
   test "should not transfer amount to organizer because the token is not valid" do
     skip("migrate to stripe")
     @mkt.marketplace.bank_account_active.update_attributes(:own_id => "fooid")
     post :transfer_funds, id: @mkt.id, amount: 200, current: 500
     assert_equal assigns(:bank_account_active_id), "fooid"
     assert_equal assigns(:amount), 20000
     assert_equal assigns(:response_transfer_json), {"ERROR"=>"Token or Key are invalids"}
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:message_status), "Você não está autorizado a realizar esta transação"
     assert_response :success
   end
   
   test "should not transfer amount with moip response of any error" do
     skip("migrate to stripe")
     body = {"errors"=>[{"code"=>"TRA-101", "path"=>"-", "description"=>"Saldo disponivel insuficiente para essa operacao"}]}
     FakeWeb.register_uri(:post, "#{Rails.application.secrets[:moip_domain]}/transfers", :body => body.to_json, :status => ["200", "Success"])
     @mkt.marketplace.bank_account_active.update_attributes(:own_id => "fooid")
     post :transfer_funds, id: @mkt.id, amount: 200, current: 500
     assert_equal assigns(:bank_account_active_id), "fooid"
     assert_equal assigns(:amount), 20000
     assert_equal assigns(:response_transfer_json), {"errors"=>[{"code"=>"TRA-101", "path"=>"-", "description"=>"Saldo disponivel insuficiente para essa operacao"}]}
     assert_equal assigns(:status), "danger"
     assert_equal assigns(:message_status), "Não foi possível realizar a transferência"
     assert_response :success
   end 
   
   test "should transfer amount successfully with moip response" do
     skip("migrate to stripe")
     body = {:status => "REQUESTED", :amount => 2000, :updatedAt => "2017-01-17T20:13:52.017-02", :transferInstrument => {:bankAccount => {:holder => { :fullname => 'foo' }, :bankName => 'foo', :accountNumber => 'foo'}}}
     FakeWeb.register_uri(:post, "https://sandbox.moip.com.br/v2/transfers", :body => body.to_json, :status => ["201", "Created"])
     @mkt.marketplace.bank_account_active.update_attributes(:own_id => "fooid")
     post :transfer_funds, id: @mkt.id, amount: 200, current: 500
     assert_equal assigns(:bank_account_active_id), "fooid"
     assert_equal assigns(:amount), 20000
     assert_equal assigns(:response_transfer_json)["status"], "REQUESTED"
     assert_equal assigns(:status), "success"
     assert_equal assigns(:message_status), "Solicitação de transferência realizada com sucesso"
     assert_response :success
     assert_not ActionMailer::Base.deliveries.empty?
   end  
   
 end
