require 'test_helper'
include Devise::TestHelpers

class BankAccountsControllerTest < ActionController::TestCase
  setup do
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    @bank_account = bank_accounts(:one)
    @registered_bank_account = bank_accounts(:registered)
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
    skip("not creating because of bank number without no reason")
    assert_difference('BankAccount.count') do
      post :create, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, bank_type: @bank_account.bank_type }
    end

    assert_redirected_to bank_account_path(assigns(:bank_account))
  end

  test "should show bank_account" do
    get :show, id: @bank_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bank_account
    assert_response :success
  end

  test "should update bank_account" do
    skip("some issue in update bank account")
    patch :update, id: @bank_account, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, type: @bank_account.type }
    assert_redirected_to bank_account_path(assigns(:bank_account))
  end

  test "should destroy bank_account" do
    assert_difference('BankAccount.count', -1) do
      delete :destroy, id: @bank_account
    end

    assert_redirected_to bank_accounts_path
  end
  
  test "should not activate bank_account with wrong data" do
    get :activate, id: @bank_account
    assert_equal assigns(:activation_message), "Não foi possível ativar o marketplace para #{@bank_account.marketplace.organizer.name} devido a erro na autenticação"
    assert_equal assigns(:activation_status), "danger"
    assert_equal assigns(:errors), {"ERROR"=>"Token or Key are invalids"}  
    assert_response :success
  end
  
  test "should activate a bank_account with the right data and associate with a id" do
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
    assert_equal assigns(:activation_message), "Esta conta bancária do #{@registered_bank_account.marketplace.organizer.name} já foi ativada"
    assert_equal assigns(:errors), { :errors => { :description => "já tem uma conta no moip associada a esta conta"} }
    assert_response :success
    
  end
  
  
  
end
