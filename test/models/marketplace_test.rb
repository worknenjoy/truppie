require 'test_helper'
require 'stripe_mock'

class MarketplaceTest < ActiveSupport::TestCase
  
  
  def setup
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    @mkt_active = marketplaces(:one)
    @mkt_real_data = marketplaces(:real)
  end
  
  def tearDown
    StripeMock.stop
  end
  
  test "two Marketplaces" do
    assert_equal 3, Marketplace.count
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
    account = @mkt_real_data.activate
    assert_equal account, custom_error
  end
  
  test "Returning a error from api when has conection error" do
    custom_error = Stripe::APIConnectionError.new(401, "The comunication failed somehow")
    StripeMock.prepare_error(custom_error, :new_account)
    account = @mkt_real_data.activate
    assert_equal account, custom_error
  end
  
  test "Returning a error from api when has auth error" do
    custom_error = Stripe::AuthenticationError.new(401, "Authentication failed, maybe invalid keys")
    StripeMock.prepare_error(custom_error, :new_account)
    account = @mkt_real_data.activate
    assert_equal account, custom_error
  end
  
  test "the new registered account has the id and token from account" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal Marketplace.find(@mkt_real_data.id).account_id, 'test_acct_1'
    assert_equal Marketplace.find(@mkt_real_data.id).token, 'SECRETKEY'
    assert_equal Marketplace.find(@mkt_real_data.id).auth_data, {
        "id" => 'test_acct_1',
        "token" => 'SECRETKEY'
      }
  end
  
  test "the new registered account register all possible info from a marketplace account" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.business_name, "Utopicos Mundo Afora"
    assert_equal account.business_url, Marketplace.find(@mkt_real_data.id).organizer.website
    assert_equal account.display_name, Marketplace.find(@mkt_real_data.id).organizer.name
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
    @mkt_real_data.update_attributes(:person_name => 'foo2')
    updated = @mkt_real_data.update_account
    assert_equal updated.legal_entity.first_name, 'foo2'
  end
  
  test "get missing data" do
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    assert Marketplace.find(@mkt_real_data.id).account_missing, []
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
    #assert_equal account, error
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
  
  test "send e-mail when activating a account sucessfully" do
    
  end
  
  test "get registered bank accounts" do
    skip("better handler by the mock")
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    bank_account = @mkt_real_data.registered_bank_account
    assert_equal bank_account, []
  end
  
  test "return bank account active details" do
    bank_account = 
    {
      "object" => "bank_account",
      "account_number" => "MyString",
      "country" => "MyString",
      "currency" => "BRL",
      "account_holder_name" => "MyString",
      "account_holder_type" => "personal",
      "routing_number" => "MyString"
    }
    assert_equal @mkt_active.bank_account, bank_account 
  end
  
  test "is really not active" do
    assert_equal @mkt_real_data.is_active?, false
  end
  
  test "activate a new bank account" do
    skip("better handling")
    account = @mkt_real_data.activate
    assert_equal account.id, 'test_acct_1'
    assert_equal account.email, 'organizer@mail.com'
    bank_account = Marketplace.find(@mkt_real_data.id).register_bank_account
    assert_equal bank_account.message, "No such account: test_acct_1/bank_accounts" 
  end
  
end
