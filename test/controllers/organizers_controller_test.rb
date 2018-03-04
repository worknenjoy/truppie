 include Devise::TestHelpers
 require 'test_helper'
 begin
   require 'minitest/mock'
   require 'minitest/unit'
   MiniTest.autorun
 rescue LoadError => e
   raise e unless ENV['RAILS_ENV'] == "production"
 end
 
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
    
     @other_organizer = {
       name: "Utópicos mundo afora",
       description: "uma agencia utopica",
       email: "utopicos@gmail.com",
       website: "http://website",
       facebook: "a facebook",
       twitter: "a twitter",
       instagram: "a instagram",
       phone: "a phone",
       mail_notification: false,
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
     #assert_not ActionMailer::Base.deliveries.empty?
     assert_redirected_to organizer_path(assigns(:organizer))
   end

   test "should create organizer basic" do
     assert_difference('Organizer.count') do
       post :create, organizer: @organizer
     end
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal flash[:notice], "Sua conta como guia foi criada com sucesso"
     assert_redirected_to organizer_path(assigns(:organizer))
   end
  
  test "should not send notification to organizer if disable" do
     ActionMailer::Base.deliveries.clear
     assert_difference('Organizer.count') do
       post :create, organizer: @other_organizer
     end
     assert ActionMailer::Base.deliveries.empty?
     assert_equal flash[:notice], "Sua conta como guia foi criada com sucesso"
     assert_redirected_to organizer_path(assigns(:organizer))
   end

   test "should use the same place if exist already" do
     @organizer["where"]
     assert_difference('Organizer.count') do
       post :create, organizer: @organizer
     end
     #assert_not ActionMailer::Base.deliveries.empty?
     assert_equal flash[:notice], "Sua conta como guia foi criada com sucesso"
     assert_redirected_to organizer_path(assigns(:organizer))
   end

   test "should not create empty organizer" do
     @organizer_basic = {}
     post :create, organizer: @organizer_basic
     #assert ActionMailer::Base.deliveries.empty?
     assert_equal flash[:notice], I18n.t('organizer-create-issue-message')
     assert_redirected_to organizer_welcome_url
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

   test "should get edit profile" do
     get :profile_edit, id: @organizer_ready.id
     assert_response :success
   end

   test "should invite a guide" do
     get :invite
     assert_response :success
   end

   test "should send invite to a guide" do
     post :send_invite, {:invited => Organizer.last}
     assert assigns(:invited), Organizer.last
     assert_equal flash[:notice], I18n.t('guide-invite-successfull')
     assert_not_nil Organizer.last.invite_token
     assert_not ActionMailer::Base.deliveries.empty?
     #puts ActionMailer::Base.deliveries[1].html_part
     assert_redirected_to invite_path
   end

   test "should accepct an invite to a guide" do
     @organizer = Organizer.last
     @organizer.update_attributes({:invite_token => '12345'})
     get :accept_invite, {id: @organizer.id, token: '12345'}
     assert_equal flash[:notice], "Sua conta de guia foi criada"
     assert_redirected_to organizer_path(@organizer)
   end

   test "should not accepct an invalid invite a guide" do
     @organizer = Organizer.last
     @organizer.update_attributes({:invite_token => '123fafafafa45'})
     get :accept_invite, {id: @organizer.id, token: '12345'}
     assert_equal flash[:notice], "Convite inválido"
     assert_redirected_to root_path
   end

   test "should get account" do
     get :account, id: @organizer_ready.id
     assert_response :success
   end

   test "should get missing requirements to account" do
     get :account, id: @organizer_ready.id
     assert_equal assigns(:missing_info), {
         marketplace: I18n.t("no-marketplace")
     }
   end

   test "should get missing requirements after marketplace activated" do
     skip('not really activating')
     account = @guide_mkt_validated.marketplace.activate

     get :account, id: @guide_mkt_validated.id
     assert_equal assigns(:missing_info), []
   end

   test "should update organizer" do
     source = "http://test/organizers/#{@organizer}"
     request.env["HTTP_REFERER"] = source
     patch :update, id: @organizer_ready.id, organizer: @organizer 
     #assert_not ActionMailer::Base.deliveries.empty?
     assert_redirected_to source
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
     skip('guided tour page opens successfully')
     get :guided_tour, id: @organizer_ready.id

     assert_not_nil assigns(:guided_tour), @organizer_ready.tours.new
     assert_response :success
   end

   test "should display the edit form" do
     skip('guided edit form')
     post :edit_guided_tour, {id: @organizer_ready.id, tour: @organizer_ready.tours.first}
     assert_equal assigns(:should_hide_form), nil
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

   test "should direct organizer to account registration" do
     get :account_edit, id: @organizer_ready.id
     assert_response :success
   end

   test "should render the organizer bank account form" do
     get :bank_account_edit, id: @organizer_ready.id
     assert_response :success
   end

   test "should load the terms in the page" do
     get :tos_acceptance, id: @organizer_ready.id
     assert_response :success 
   end
   
   test "should create policies" do
     skip("refactor policy")
     @organizer["policy"] = "almoco;jantar;cafe"
     
     assert_difference('Organizer.count') do
      post :create, organizer: @organizer
     end
     
     assert_equal Organizer.last.policy[0], "almoco"
     assert_equal Organizer.last.policy[1], "jantar"
     assert_equal Organizer.last.policy[2], "cafe"
   end
   
   test "should create with no members" do
     skip('no members for now')
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
     skip("not activating for real too")
     account = @guide_mkt_validated.marketplace.activate
     Stripe::Account.stub :retrieve, account do
       assert_equal account.id.include?('acct_'), true
       post :tos_acceptance_confirm, id: @guide_mkt_validated, ip: '100.22.10.1'
       assert_equal assigns(:ip), "100.22.10.1"
       assert_equal assigns(:status_message), "Seus termos foram aceitos com sucesso"
       assert_equal assigns(:status), "success"
       assert_response :success
     end
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

   test "should load the calendar page" do
     get :schedule, id: @mkt.id
     assert_response :success
   end

   test "should load the clients page" do
     get :clients, id: @mkt.id
     assert_response :success
   end

   test "should list events from facebook of the organizer" do
     response_body = {"data"=>[{"description"=>"Vou comemorar meu aniversário hoje Nó de Corda Rosas, a partir das 20:00, com uma cervejinha e cachaça com mel de leve.\n\nE sábado pra comemorar direito lhes convido para a Festa Da Música Tupiniquim:\n\nhttps://www.facebook.com/events/1658444127765080/?ref=ts&fref=ts", "name"=>"Aniversário", "place"=>{"name"=>"Parque Das Rosas - Barra Da Tijuca", "location"=>{"latitude"=>-23.003000331376, "longitude"=>-43.349793013295}, "id"=>"276507949199490"}, "start_time"=>"2015-10-08T20:00:00-0300", "id"=>"199210710409935", "rsvp_status"=>"attending"}, {"description"=>"O Gandhifica está de volta com música nova e muito Rock para celebrar uma boa música com uma boa cerveja na Cervejaria Therezópolis, no Downtown, com convidados mais que especiais.\n\nSerá nesta próxima sexta, a partir das 19:00.\n\nO Gandhifica é formado por Adriana Ramalho e Alexandre Magno Teles, que farão voz e violão tocando suas versões de vários Rocks e MPB com um toque de bossa nova e reggae", "end_time"=>"2015-07-17T22:00:00-0300", "name"=>"Show do Gandhifica na Cervejaria Therezópolis - Downtown", "place"=>{"name"=>"DowntownRJ", "location"=>{"city"=>"Rio de Janeiro", "country"=>"Brazil", "latitude"=>-23.0045624, "longitude"=>-43.3197021, "state"=>"RJ", "street"=>"Avenida das Américas, 500 - Barra da Tijuca", "zip"=>"22640100"}, "id"=>"100342806685671"}, "start_time"=>"2015-07-17T19:00:00-0300", "id"=>"867199850030220", "rsvp_status"=>"attending"}], "paging"=>{"cursors"=>{"before"=>"QVFIUkJvS1E0TDkxaUVpbGE2Q2hJcm5VOWZAnSDduWUNxV1JWSF9NaW1qVGdjd09QMDVHRW1vSzJ5Q0JkaVVuTTZAUQ2NLM3FRMUtiYmRsZAWphV1ZA2cnRqTGV3", "after"=>"QVFIUlQxOW5fWWFaaWhLWF9hRTVkMzdNNU5EblE3ekl3dlFPX0FiazBXOVRzbEtRLWhPX1BtMnM4X1lDam1IRE1wa0Q2TVVxdXpVSm9CT2kzWWlKeldhRm93"}, "next"=>"https://graph.facebook.com/v2.9/10154033067028556/events?type=created&limit=2&after=QVFIUlQxOW5fWWFaaWhLWF9hRTVkMzdNNU5EblE3ekl3dlFPX0FiazBXOVRzbEtRLWhPX1BtMnM4X1lDam1IRE1wa0Q2TVVxdXpVSm9CT2kzWWlKeldhRm93"}}
     FakeWeb.register_uri(:get, "https://graph.facebook.com/v2.9/user/events?type=created&limit=5", :body => response_body.to_json, :status => ["200", "Success"])
     get :external_events, { id: @mkt.id, source: 'facebook', format: :json,  token: '1234', user_id: 'user'}
     assert_equal assigns(:source), 'facebook'
     assert_equal assigns(:token), '1234'
     assert_equal assigns(:user_id), 'user'
     assert_equal assigns(:response_json), JSON.load(response_body.to_json)
     assert_response :success
     assert_equal JSON.load(response.body)[0]["name"], "Aniversário"
   end

   test "should not receive the import action to create new event from request" do

     post :import_events, { id: @mkt.id }
     assert_equal flash[:error], I18n.t('import-event-notice-error')
     assert_redirected_to "/organizers/#{@mkt.to_param}/guided_tour"
   end

   test "should receive the import action to create new event from request" do
     skip("not working")
     response_body = {"description"=> "foo", "name"=> "Aniversário", "place"=> {"name" => "Parque Das Rosas - Barra Da Tijuca", "location"=> {"latitude" => -23.003000331376, "longitude" => -43.349793013295}, "id" => "276507949199490"}, "start_time" => "2015-10-08T20:00:00-0300", "id" => "199210710409935"}
     response_picture = {"cover" => {"source" => "pic"}}
     FakeWeb.register_uri(:get, "https://graph.facebook.com/v2.9/199210710409935", :body => response_body.to_json, :status => ["200", "Success"])
     FakeWeb.register_uri(:get, "https://graph.facebook.com/v2.9/199210710409935/?fields=cover", :body => response_picture.to_json, :status => ["200", "Success"])
     post :import_events, { id: @mkt.id, events: ["199210710409935"], facebook_token: '1234', facebook_user_id: 'user'}
     assert_equal assigns(:organizer), @mkt
     assert_equal assigns(:tour), Tour.last
     assert_equal assigns(:response)[0]["name"], "Aniversário"
     assert_equal Tour.last.title, "Aniversário"
     assert_equal Tour.last.link, "http://www.facebook.com/events/199210710409935"
     assert_equal Tour.last.photo, "pic"
     assert_equal flash[:success], I18n.t('import-event-notice-success')
     assert_redirected_to "/organizers/#{@mkt.to_param}/edit_guided_tour/#{Tour.last.to_param}"
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
