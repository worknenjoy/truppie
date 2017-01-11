include Devise::TestHelpers

class MarketplacesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:alexandre)
    @marketplace = marketplaces(:one)
    @mkt_valid = marketplaces(:real)
    FakeWeb.clean_registry
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
  
  test "activate marketplace with wrong data" do
    get :activate, id: @marketplace
    assert_equal assigns(:activation_message), "Não foi possível ativar o marketplace para #{@marketplace.organizer.name}, verifique os dados novamente."
    assert_equal assigns(:activation_status), "danger"
    assert_equal assigns(:errors), {"errors"=>[{"code"=>"REG-014", "path"=>"v2/accounts", "description"=>"person[taxDocument][0][number] is empty"}, {"code"=>"REG-005", "path"=>"v2/accounts", "description"=>"person[address][0][streetNumber] is invalid"}, {"code"=>"REG-008", "path"=>"v2/accounts", "description"=>"person[address][0][zipcode] is invalid"}, {"code"=>"REG-010", "path"=>"v2/accounts", "description"=>"person[address][0][state] is invalid"}, {"code"=>"REG-011", "path"=>"v2/accounts", "description"=>"person[address][0][country] is invalid"}]}  
    assert_response :success
  end
  
  test "activate marketplace with success mocking the success response from moip and get the id" do
    body = "{\"id\":\"MPA-EA639011F6DD\",\"login\":\"organizer@mail.com\",\"accessToken\":\"06f4ceba740f4ff892146d13be869471_v2\",\"channelId\":\"APP-FAW8Z1CC1JNB\",\"type\":\"MERCHANT\",\"transparentAccount\":true,\"email\":{\"address\":\"organizer@mail.com\",\"confirmed\":false},\"person\":{\"name\":\"Alexandre Magno\",\"lastName\":\"Teles Zimerer\",\"birthDate\":\"1982-06-10\",\"taxDocument\":{\"type\":\"CPF\",\"number\":\"123.456.798-91\"},\"address\":{\"street\":\"Av. Brigadeiro Faria Lima\",\"streetNumber\":\"2927\",\"district\":\"Barra da Tijuca\",\"zipcode\":\"22640338\",\"zipCode\":\"22640338\",\"city\":\"Rio de Janeiro\",\"state\":\"RJ\",\"country\":\"BRA\",\"complement\":\"apto 403A\"},\"phone\":{\"countryCode\":\"55\",\"areaCode\":\"11\",\"number\":\"965213244\"},\"identityDocument\":{\"number\":\"12345678\",\"issuer\":\"SSPMG\",\"issueDate\":\"1990-01-01\",\"type\":\"RG\"}},\"businessSegment\":{\"id\":37,\"name\":\"Turismo\",\"mcc\":null},\"site\":\"http://www.truppie.com\",\"createdAt\":\"2017-01-10T16:46:09.776Z\",\"_links\":{\"self\":{\"href\":\"https://sandbox.moip.com.br/moipaccounts/MPA-EA639011F6DD\",\"title\":null}}}"
    FakeWeb.register_uri(:post, "https://sandbox.moip.com.br/v2/accounts", :body => body, :status => ["201", "Success"])
    get :activate, id: @mkt_valid
    assert_equal assigns(:activation_message), "Conseguimos com sucesso criar uma conta no marketplace para #{@marketplace.organizer.name}"
    assert_equal assigns(:activation_status), "success"
    assert_equal assigns(:response)["id"], "MPA-EA639011F6DD"
    assert_equal Marketplace.find(@mkt_valid.id).organizer.market_place_active, true
    assert_equal Marketplace.find(@mkt_valid.id).active, true
    assert_equal Marketplace.find(@mkt_valid.id).is_active?, true
    assert_equal Marketplace.find(@mkt_valid.id).token, "06f4ceba740f4ff892146d13be869471_v2"
    assert_equal Marketplace.find(@mkt_valid.id).account_id, "MPA-EA639011F6DD"
    assert_equal Marketplace.find(@mkt_valid.id).auth_data, {
        "id" => "MPA-EA639011F6DD",
        "token" => "06f4ceba740f4ff892146d13be869471_v2"
      }
    assert_response :success
  end
  
  test "activate bank account on marketplace with success mocking the success response from moip and get the data" do
    body = "{\"id\":\"MPA-EA639011F6DD\",\"login\":\"organizer@mail.com\",\"accessToken\":\"06f4ceba740f4ff892146d13be869471_v2\",\"channelId\":\"APP-FAW8Z1CC1JNB\",\"type\":\"MERCHANT\",\"transparentAccount\":true,\"email\":{\"address\":\"organizer@mail.com\",\"confirmed\":false},\"person\":{\"name\":\"Alexandre Magno\",\"lastName\":\"Teles Zimerer\",\"birthDate\":\"1982-06-10\",\"taxDocument\":{\"type\":\"CPF\",\"number\":\"123.456.798-91\"},\"address\":{\"street\":\"Av. Brigadeiro Faria Lima\",\"streetNumber\":\"2927\",\"district\":\"Barra da Tijuca\",\"zipcode\":\"22640338\",\"zipCode\":\"22640338\",\"city\":\"Rio de Janeiro\",\"state\":\"RJ\",\"country\":\"BRA\",\"complement\":\"apto 403A\"},\"phone\":{\"countryCode\":\"55\",\"areaCode\":\"11\",\"number\":\"965213244\"},\"identityDocument\":{\"number\":\"12345678\",\"issuer\":\"SSPMG\",\"issueDate\":\"1990-01-01\",\"type\":\"RG\"}},\"businessSegment\":{\"id\":37,\"name\":\"Turismo\",\"mcc\":null},\"site\":\"http://www.truppie.com\",\"createdAt\":\"2017-01-10T16:46:09.776Z\",\"_links\":{\"self\":{\"href\":\"https://sandbox.moip.com.br/moipaccounts/MPA-EA639011F6DD\",\"title\":null}}}"
    FakeWeb.register_uri(:post, "https://sandbox.moip.com.br/v2/accounts", :body => body, :status => ["201", "Success"])
    get :activate, id: @mkt_valid
    assert_equal assigns(:activation_message), "Conseguimos com sucesso criar uma conta no marketplace para #{@marketplace.organizer.name}"
    assert_equal assigns(:activation_status), "success"
    assert_equal assigns(:response)["id"], "MPA-EA639011F6DD"
    assert_equal Marketplace.find(@mkt_valid.id).organizer.market_place_active, true
    assert_response :success
  end
  
  
end
