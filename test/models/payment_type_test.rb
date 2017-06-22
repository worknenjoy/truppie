require 'test_helper'

class PaymentTypeTest < ActiveSupport::TestCase
  test "a payment type of pagseguro should return the app auth url" do
    p = payment_types(:one)
    assert_equal p.auth_url, 'https://pagseguro.uol.com.br/v2/authorization/request.jhtml?code=MyString'
  end
end
