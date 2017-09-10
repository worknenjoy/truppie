require 'test_helper'
require 'stripe_mock'

class MarketplaceTest < ActiveSupport::TestCase
  setup do
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    @mkt_active = marketplaces(:one)
    @mkt_real_data = marketplaces(:real)
  end
  
  teardown do
    StripeMock.stop
  end
  
  test "two Marketplaces" do
    assert_equal 5, Marketplace.count
  end
  
  test "split phone into a object" do
     assert_equal @mkt_active.phone_object, {"countryCode"=>"55", "areaCode"=>"11", "number"=>"965213244"}
  end
  
  test "return bank data account" do
    assert_equal @mkt_active.account_info, {"email"=> {"address"=>"organizer@mail.com"}, "person"=>{"name"=>"MyString", "lastName"=>"MyString", "taxDocument"=>{"type"=>"MyString", "number"=>nil}, "identityDocument"=>{"type"=>"MyString", "number"=>"MyString", "issuer"=>"MyString", "issueDate"=>"MyString"}, "birthDate"=>"2017-01-08", "phone"=>{"countryCode"=>"55", "areaCode"=>"11", "number"=>"965213244"}, "address"=>{"street"=>"MyString", "streetNumber"=>"MyString", "complement"=>"MyString", "district"=>"MyString", "zipcode"=>"MyString", "city"=>"MyString", "state"=>"MyString", "country"=>"MyString"}}, "businessSegment"=>{"id"=>"37"}, "site"=>"http://www.truppie.com", "type"=>"MERCHANT", "transparentAccount"=>"true"} 
  end
  
  test "return auth data" do
    assert_equal @mkt_active.auth_data, {"id"=>"MPA-014A72F4426C", "token"=>"MyString"}
  end
  
  test "return no auth data if is not active" do
    assert_equal @mkt_real_data.auth_data, false
  end
  
  test "try to register a account already active" do
    assert_equal @mkt_active.activate, false
  end
  
  test "try to register a new simple account" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
  end
  
  test "Returning a error when try to create an account" do
    custom_error = Stripe::InvalidRequestError.new(401, "Invalid API Key provided: **aaaa>")
    StripeMock.prepare_error(custom_error, :new_account)
    assert_raise Stripe::InvalidRequestError do 
      @mkt_real_data.activate      
    end
  end
  
  test "Returning a error from api when has conection error" do
    custom_error = Stripe::APIConnectionError.new(401, "The comunication failed somehow")
    StripeMock.prepare_error(custom_error, :new_account)
    assert_raise Stripe::APIConnectionError do
      @mkt_real_data.activate
    end
  end
  
  test "Returning a error from api when has auth error" do
    custom_error = Stripe::AuthenticationError.new(401, "Authentication failed, maybe invalid keys")
    StripeMock.prepare_error(custom_error, :new_account)
    assert_raise Stripe::AuthenticationError do 
      @mkt_real_data.activate      
    end
  end
  
  test "the new registered account has the id and token from account" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal Marketplace.find(@mkt_real_data.id).account_id, 'test_acct_1'
    assert_equal Marketplace.find(@mkt_real_data.id).token, 'sk_test_AmJhMTLPtY9JL4c6EG0'
    assert_equal Marketplace.find(@mkt_real_data.id).auth_data, {
        "id" => 'test_acct_1',
        "token" => 'sk_test_AmJhMTLPtY9JL4c6EG0'
      }
  end
  
  test "the new registered account register all possible info from a marketplace account" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.business_name, "Utopicos Mundo Afora"
    assert_equal account.business_url, Marketplace.find(@mkt_real_data.id).organizer.website
    assert_equal account.legal_entity.first_name, Marketplace.find(@mkt_real_data.id).person_name
    assert_equal account.legal_entity.last_name, Marketplace.find(@mkt_real_data.id).person_lastname
    assert_equal account.legal_entity.personal_id_number, Marketplace.find(@mkt_real_data.id).document_number
    assert_equal account.legal_entity.dob.to_json, Marketplace.find(@mkt_real_data.id).dob.to_json
    assert_equal account.legal_entity.personal_address.city, Marketplace.find(@mkt_real_data.id).city
    assert_equal account.legal_entity.personal_address.country, Marketplace.find(@mkt_real_data.id).country
    assert_equal account.legal_entity.personal_address.line1, Marketplace.find(@mkt_real_data.id).street
    assert_equal account.legal_entity.personal_address.line2, Marketplace.find(@mkt_real_data.id).complement
    assert_equal account.legal_entity.personal_address.state, Marketplace.find(@mkt_real_data.id).state
    assert_equal account.legal_entity.personal_address.postal_code, Marketplace.find(@mkt_real_data.id).zipcode
    assert_equal account.product_description, Marketplace.find(@mkt_real_data.id).organizer.description
    assert_equal account.legal_entity.type, Marketplace.find(@mkt_real_data.id).organizer_type
  end
  
  test "updating a account active remote" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    @mkt_real_data.update_attributes(:person_name => 'foo2', :person_lastname => 'bla')
    updated = @mkt_real_data.update_account
    assert_equal updated.legal_entity.first_name, 'foo2'
    assert_equal updated.legal_entity.last_name, 'bla'
  end
  
  test "error when updating a account" do
    custom_error = Stripe::InvalidRequestError.new(401, "Authentication failed, maybe invalid keys")
    StripeMock.prepare_error(custom_error, :update_account)
    
    assert_raise Stripe::InvalidRequestError do 
      @mkt_active.update_account     
    end
  end
  
  test "get missing data" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    assert Marketplace.find(@mkt_real_data.id).account_missing, []
  end

  test "get missing data when the marketplace is active and missing data" do

    mkt = @mkt_real_data

    def mkt.account_missing
      { disabled_reason: "fields_needed", due_by: nil, fields_needed: [ "external_account", "legal_entity.personal_id_number", "tos_acceptance.date", "tos_acceptance.ip" ] }
    end

    assert_equal mkt.account_needed, [
        {
            name: "external_account",
            label: I18n.t('account-missing-external-account-label'),
            message: I18n.t('account-missing-external-account-message')
        },
        {
            name: "legal_entity.personal_id_number",
            label: I18n.t('account-missing-legal-entity.personal-id-number-label'),
            message: I18n.t('account-missing-legal-entity.personal-id-number-message')
        },
        {
            name: "tos_acceptance.date",
            label: I18n.t('account-missing-tos-acceptance.date-label'),
            message: I18n.t('account-missing-tos-acceptance.date-message')
        },
        {
            name: "tos_acceptance.ip",
            label: I18n.t('account-missing-tos-acceptance.ip-label'),
            message: I18n.t('account-missing-tos-acceptance.ip-message')
        },
    ]
  end

  test "check if the account is fully verified" do

    mkt = @mkt_real_data

    def mkt.account_missing
      { disabled_reason: "fields_needed", due_by: nil, fields_needed: [ "external_account", "legal_entity.personal_id_number", "tos_acceptance.date", "tos_acceptance.ip" ] }
    end

    assert_equal mkt.account_full_verified, false
  end

  
  test "deactivating a account not active" do
    try_to_deactivate = @mkt_real_data.deactivate
    assert_equal try_to_deactivate, false
  end
  
  test "deactivating a account not found" do
    skip("delete not working yet")
    error = Stripe::InvalidRequestError.new("(Status 404) No such account: MPA-014A72F4426C", 404)
    StripeMock.prepare_error(error, :get_account)
    account = @mkt_active.deactivate
    assert_raises(Stripe::InvalidRequestError) { error }
  end
  
  test "deactivating a account successfully" do
    skip("delete not working yet")
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    
    deleted_account = @mkt_real_data.deactivate
    assert_equal deleted_account.deleted, true
    assert_equal deleted_account.id, 'test_acct_1'
  end
  
  test "get registered bank accounts" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    bank_account = @mkt_real_data.registered_bank_account
    assert_equal bank_account, []
  end
  
  test "return bank account active details" do
    bank_account = 
    {:object=>"bank_account", :account_number=>"MyString", :default_for_currency=>true, :country=>"MyString", :currency=>"BRL", :account_holder_name=>"MyString", :account_holder_type=>"individual", :routing_number=>"MyString-MyString"}
    assert_equal @mkt_active.bank_account, bank_account 
  end
  
  test "is really not active" do
    assert_equal @mkt_real_data.is_active?, false
  end
  
  test "activate a new bank account" do
    skip("not activating account")
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    assert_raises(Stripe::InvalidRequestError) { 
      bank_account = Marketplace.find(@mkt_real_data.id).register_bank_account  
    }
  end
  
  test "should accept terms" do
     account = @mkt_real_data.activate
     accepted_terms = @mkt_real_data.accept_terms('110.112.113.2')  
     assert_equal accepted_terms, true
  end

  test "should create marketplace with external payment system" do
    mkt = marketplaces(:one)

    mkt.payment_types.create({
      type_name: 'pagseguro',
      email: 'payment@pagseguro.com',
      token: 'abc',
      appId: '1234',
      auth: 'aaaa',
      key: '2345'
    })

    assert_equal mkt.payment_types.first.type_name, 'pagseguro'
    assert_equal mkt.payment_types.first.email, 'payment@pagseguro.com'
    assert_equal mkt.payment_types.first.token, 'abc'
    assert_equal mkt.payment_types.first.appId, '1234'
    assert_equal mkt.payment_types.first.auth, 'aaaa'
    assert_equal mkt.payment_types.first.key, '2345'
  end

  test "should see the payment type authorization" do
    url = 'https://ws.pagseguro.uol.com.br/v2/authorizations/request?appId=truppie&appKey=CDEF210C5C5C6DFEE4E36FBE9DB6F509'
    xml_body = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><authorizationRequest><code>1234</code><date>2017-06-22T13:02:46.000-03:00</date></authorizationRequest>'
    FakeWeb.register_uri(:post, url, :body => xml_body, :status => ["200", "Success"])

    mkt = marketplaces(:one)

    mkt.payment_types.create({
       type_name: 'pagseguro',
       email: 'payment@pagseguro.com'
   })

    assert_equal mkt.payment_types_authorize, '1234'
    assert_equal mkt.payment_types.first.auth, '1234'
  end

end
