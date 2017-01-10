require 'test_helper'
include Devise::TestHelpers

class MarketplacesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @marketplace = marketplaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marketplaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marketplace" do
    skip("fix type")
    assert_difference('Marketplace.count') do
      post :create, marketplace: { account_id: @marketplace.account_id, active: @marketplace.active, bank_accounts_id: @marketplace.bank_accounts_id, birthDate: @marketplace.birthDate, city: @marketplace.city, complement: @marketplace.complement, country: @marketplace.country, district: @marketplace.district, document_type: @marketplace.document_type, id_issuer: @marketplace.id_issuer, id_issuerdate: @marketplace.id_issuerdate, id_number: @marketplace.id_number, id_type: @marketplace.id_type, organizer_id: @marketplace.organizer_id, person_lastname: @marketplace.person_lastname, person_name: @marketplace.person_name, state: @marketplace.state, street: @marketplace.street, street_number: @marketplace.street_number, token: @marketplace.token, zipcode: @marketplace.zipcode }
    end

    assert_redirected_to marketplace_path(assigns(:marketplace))
  end

  test "should show marketplace" do
    get :show, id: @marketplace
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @marketplace
    assert_response :success
  end

  test "should update marketplace" do
    skip("fix type")
    patch :update, id: @marketplace, marketplace: { account_id: @marketplace.account_id, active: @marketplace.active, bank_accounts_id: @marketplace.bank_accounts_id, birthDate: @marketplace.birthDate, city: @marketplace.city, complement: @marketplace.complement, country: @marketplace.country, district: @marketplace.district, document_type: @marketplace.document_type, id_issuer: @marketplace.id_issuer, id_issuerdate: @marketplace.id_issuerdate, id_number: @marketplace.id_number, id_type: @marketplace.id_type, organizer_id: @marketplace.organizer_id, person_lastname: @marketplace.person_lastname, person_name: @marketplace.person_name, state: @marketplace.state, street: @marketplace.street, street_number: @marketplace.street_number, token: @marketplace.token, zipcode: @marketplace.zipcode }
    assert_redirected_to marketplace_path(assigns(:marketplace))
  end

  test "should destroy marketplace" do
    skip("some issue to destroy the marketplace")
    assert_difference('Marketplace.count', -1) do
      delete :destroy, id: @marketplace
    end
    assert_redirected_to marketplaces_path
  end
  
  test "activate marketplace" do
    get :activate, id: @marketplace
    assert_equal "Não foi possível ativar o marketplace para o #{@marketplace.organizer.name}, verifique os dados novamente.", flash[:error]
    assert_redirected_to marketplaces_path
  end
  
end
