require 'test_helper'

class MarketplaceTest < ActiveSupport::TestCase
  
  def setup
    @mkt_active = marketplaces(:one)
    @mkt_real_data = marketplaces(:real)
    FakeWeb.clean_registry
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
  
  test "return bank account active details" do
    bank_account = 
    {
      "bankNumber" => "MyString",
      "agencyNumber" => "MyString",
      "accountNumber" => "MyString",
      "agencyCheckNumber" => "MyString",
      "accountCheckNumber" => "MyString",
      "type" => "MyString",
      "holder" => {
        "taxDocument" => {
          "type" => "MyString",
          "number" => "MyString"
        },
        "fullname" => "MyString"
      }
    }
    assert_equal @mkt_active.bank_account, bank_account 
  end
  
  test "is really not active" do
    assert_equal @mkt_real_data.is_active?, false
  end
  
  test "is really active" do
    @mkt_real_data.update_attributes(:account_id => "foo", :token => "bar", :active => true)
    assert_equal @mkt_real_data.is_active?, true
  end
  
  test "get registered account with no account" do
    body = "[]"
    FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/accounts/#{@mkt_active.account_id}/bankaccounts", :body => body, :status => ["201", "Success"])
    account = @mkt_active.registered_account
    assert_equal account, []
  end
  
end
