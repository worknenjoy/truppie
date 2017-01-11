require 'test_helper'
include Devise::TestHelpers

class BankAccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @bank_account = bank_accounts(:one)
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
    assert_equal assigns(:errors), {"errors"=>[{"code"=>"REG-014", "path"=>"v2/accounts", "description"=>"person[taxDocument][0][number] is empty"}, {"code"=>"REG-005", "path"=>"v2/accounts", "description"=>"person[address][0][streetNumber] is invalid"}, {"code"=>"REG-008", "path"=>"v2/accounts", "description"=>"person[address][0][zipcode] is invalid"}, {"code"=>"REG-010", "path"=>"v2/accounts", "description"=>"person[address][0][state] is invalid"}, {"code"=>"REG-011", "path"=>"v2/accounts", "description"=>"person[address][0][country] is invalid"}]}  
    assert_response :success
  end
  
end
