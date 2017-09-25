require 'test_helper'
include Devise::TestHelpers
begin
  require 'minitest/mock'
  require 'minitest/unit'
  MiniTest.autorun
rescue LoadError => e
  raise e unless ENV['RAILS_ENV'] == "production"
end

class BankAccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    @bank_account = bank_accounts(:one)
    @registered_bank_account = bank_accounts(:registered)
    @mkt_real_data = marketplaces(:real)
    ActionMailer::Base.deliveries.clear
  end
  
  teardown do
    StripeMock.stop
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bank_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bank_account" do
    source = "http://test/organizers/#{@bank_account.marketplace.organizer.to_param}/bank_account_edit"
    request.env["HTTP_REFERER"] = source
    assert_difference('BankAccount.count') do
      post :create, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, bank_type: @bank_account.bank_type }
    end
    assert_redirected_to source
  end

  test "should create a new bank_account but fails remote" do
    skip("should mock now that needs to be remote")
    source = "http://test/organizers/#{@bank_account.marketplace.organizer.to_param}/bank_account_edit"
    request.env["HTTP_REFERER"] = source

    account = @mkt_real_data.activate

    assert_difference('BankAccount.count') do
      Stripe::Account.stub :retrieve, account do
        post :create, {marketplace_id: @mkt_real_data.id, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, bank_type: @bank_account.bank_type }}
        assert_equal flash[:notice], I18n.t("bank-account-data-remote-incorrect")
      end
    end

    assert_equal Marketplace.find(@mkt_real_data.id).registered_bank_account, []

    assert_redirected_to source
  end

  test "should create a new bank_account remote" do
    skip("should mock now that needs to be remote")
    source = "http://test/organizers/#{@bank_account.marketplace.organizer.to_param}/bank_account_edit"
    request.env["HTTP_REFERER"] = source

    account = @mkt_real_data.activate

    assert_difference('BankAccount.count') do
      Stripe::Account.stub :retrieve, account do
        account.external_accounts.stub :create, [] do
          post :create, {marketplace_id: @mkt_real_data.id, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, bank_type: @bank_account.bank_type }}
          assert_equal flash[:notice], I18n.t("bank_account_controller_notice_two")
          assert_equal Marketplace.find(@mkt_real_data.id).bank_accounts.size, 1
          assert_equal Marketplace.find(@mkt_real_data.id).bank_accounts.first.account_check_number, @bank_account.account_check_number
          assert_equal Marketplace.find(@mkt_real_data.id).registered_bank_account, []
        end
      end
    end

    assert_redirected_to source
  end

  test "should show bank_account" do
    get :show, id: @bank_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bank_account
    assert_response :success
  end

  test "should not update bank_account if theres incorrect data" do
    source = "http://test/organizers/#{@mkt_real_data.organizer.to_param}/account_status"
    request.env["HTTP_REFERER"] = source

    patch :update, id: @bank_account, bank_account: { account_check_number: nil, account_number: nil, agency_check_number: nil, agency_number: nil, bank_number: nil, doc_number: nil, doc_type: @bank_account.doc_type}
    assert_equal flash[:notice], I18n.t('bank-account-updated-fail')
    assert_equal flash[:errors].messages, {:bank_number=>["não pode ficar em branco"], :agency_number=>["não pode ficar em branco"], :account_number=>["não pode ficar em branco"]}
    assert_redirected_to source
  end

  test "should update bank_account" do
    source = "http://test/organizers/#{@mkt_real_data.organizer.to_param}/account_status"
    request.env["HTTP_REFERER"] = source

    patch :update, id: @bank_account, bank_account: { account_number: '2222'}
    assert_equal BankAccount.find(@bank_account.id).account_number, '2222'

    assert_equal flash[:notice], I18n.t('bank-account-sync-error')

    assert_redirected_to source
  end

  test "should destroy bank_account" do

    source = "http://test/organizers/#{@mkt_real_data.organizer.to_param}/account_status"
    request.env["HTTP_REFERER"] = source

    account = @registered_bank_account.marketplace.activate
    bank_account_mock = StripeMock::Data.mock_bank_account
    bank_account_token = @stripe_helper.generate_bank_token(bank_account_mock)
    bank_account = Stripe::BankAccount.new(external_account: bank_account_token)

    Stripe::Account.stub :retrieve, account do
      account.external_accounts.stub :retrieve, bank_account do
        assert_difference('BankAccount.count', -1) do
          delete :destroy, id: @registered_bank_account
        end
      end
    end

    assert_equal flash[:notice], I18n.t('bank-account-destroyed-successfully')

    assert_redirected_to source
  end

  test "if fails the remote, do not destroy the local" do

    source = "http://test/organizers/#{@mkt_real_data.organizer.to_param}/account_status"
    request.env["HTTP_REFERER"] = source

    Stripe::Account.stub :retrieve, 'error' do
      assert_no_difference('BankAccount.count') do
        delete :destroy, id: @registered_bank_account
      end
    end

    assert_equal flash[:notice], I18n.t('bank-account-not-deleted')

    assert_redirected_to source
  end
  
  test "should not activate bank_account with wrong data" do
    get :activate, id: @bank_account
    assert_equal assigns(:activation_message), "Tivemos um problema pra ativar esta conta bancária"
    assert_equal assigns(:activation_status), "danger"
    assert_response :success
  end
  
  test "should activate a bank_account with the right data and associate with a id" do
    skip("migrate to marketplace")
    body = {"id"=>"BKA-MFTMJF33MHJ0", "agencyNumber"=>"2345", "accountNumber"=>"12345678", "holder"=>{"thirdParty"=>false, "taxDocument"=>{"number"=>"123.456.798-91", "type"=>"CPF"}, "fullname"=>"Alexandre Teles Zimerer"}, "status"=>"NOT_VERIFIED", "createdAt"=>"2017-01-10T22:04:30.000-02:00", "accountCheckNumber"=>"2", "_links"=>{"self"=>{"href"=>"https://sandbox.moip.com.br//accounts/BKA-MFTMJF33MHJ0/bankaccounts"}}}
    FakeWeb.register_uri(:post, "https://sandbox.moip.com.br/v2/accounts/#{@bank_account.marketplace.account_id}/bankaccounts", :body => body.to_json, :status => ["201", "Created"])
    get :activate, id: @bank_account
    assert_equal assigns(:activation_status), "success"
    assert_equal assigns(:activation_message), "Conseguimos com sucesso criar uma conta no marketplace para #{@bank_account.marketplace.organizer.name}"
    assert_equal BankAccount.find(@bank_account.id).own_id, "BKA-MFTMJF33MHJ0"
    assert_response :success
  end
  
  test "should not activate a bank_account if the id already exist" do
    get :activate, id: @registered_bank_account
    assert_equal assigns(:activation_status), "danger"
    assert_equal assigns(:activation_message), I18n.translate('bank_controller_activation_msg_one', organizer: @registered_bank_account.marketplace.organizer.name)
    assert_equal assigns(:errors), "já tem uma conta associada"
    assert_response :success
    
  end
  
  
  
end
