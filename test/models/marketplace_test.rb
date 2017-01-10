require 'test_helper'

class MarketplaceTest < ActiveSupport::TestCase
  
  def setup
    @mkt_active = marketplaces(:one)
    @mkt_real_data = marketplaces(:real)
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
    assert_equal @mkt_active.auth_data, {"id"=>"MyString", "token"=>"MyString"}
  end
  
  test "return no auth data if is not active" do
    assert_equal @mkt_real_data.auth_data, false
  end
  
  test "return bank account active details" do
    skip("bank account info to send to moip")
    bank_account = 
    {
      "bankNumber" => "",
      "agencyNumber" => "",
      "accountNumber" => "",
      "agencyCheckNumber" => "",
      "accountCheckNumber" => "",
      "type" => "CHECKING",
      "holder" => {
        "taxDocument" => {
          "type" => "",
          "number" => ""
        },
        "fullname" => self.fullname
      }
    }
  end
  
  test "requesting a new account from marketplace data" do
      skip("testing a request to create account on marketplace")
      account_bank_data = @mkt_real_data.account_info
      puts account_bank_data.inspect
      response = RestClient.post "https://sandbox.moip.com.br/v2/accounts", account_bank_data.to_json, :content_type => :json, :accept => :json, :authorization => "OAuth jdyi6e28vdyz2l8e1nss0jadh1j4ay2"
      puts response.inspect
      assert_equal true, true
  end
  
  test "is really not active" do
    assert_equal @mkt_real_data.is_active?, false
  end
  
  test "is really active" do
    @mkt_real_data.update_attributes(:account_id => "foo", :token => "bar", :active => true)
    assert_equal @mkt_real_data.is_active?, true
  end
  
end
