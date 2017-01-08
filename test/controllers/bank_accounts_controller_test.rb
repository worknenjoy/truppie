require 'test_helper'

class BankAccountsControllerTest < ActionController::TestCase
  setup do
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
    assert_difference('BankAccount.count') do
      post :create, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, marketplace_id: @bank_account.marketplace_id, type: @bank_account.type }
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
    patch :update, id: @bank_account, bank_account: { account_check_number: @bank_account.account_check_number, account_number: @bank_account.account_number, active: @bank_account.active, agency_check_number: @bank_account.agency_check_number, agency_number: @bank_account.agency_number, bank_number: @bank_account.bank_number, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, marketplace_id: @bank_account.marketplace_id, type: @bank_account.type }
    assert_redirected_to bank_account_path(assigns(:bank_account))
  end

  test "should destroy bank_account" do
    assert_difference('BankAccount.count', -1) do
      delete :destroy, id: @bank_account
    end

    assert_redirected_to bank_accounts_path
  end
end
