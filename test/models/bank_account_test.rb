require 'test_helper'
require 'minitest/mock'
require 'minitest/unit'

MiniTest.autorun

class BankAccountTest < ActiveSupport::TestCase

  setup do
    StripeMock.start
    @stripe_helper = StripeMock.create_test_helper
    @bank_account = bank_accounts(:one)
    @bank_account_registered = bank_accounts(:registered)
  end

  teardown do
    StripeMock.stop
  end

  test "bank_account has an id" do
    assert_equal @bank_account_registered.own_id, 'foo'
  end

  test "bank_account has access to marketplace account" do
    account = @bank_account_registered.marketplace.activate
    assert_equal @bank_account_registered.from_account, account
  end

  test "bank_account is fetched from remote" do
    account = @bank_account_registered.marketplace.activate
    Stripe::Account.stub :retrieve, account do
      account.external_accounts.stub :retrieve, @remote_bank_account do
        assert_equal @bank_account_registered.fetch, @remote_bank_account
      end
    end
  end

  test "bank account sync with remote" do
    account = @bank_account_registered.marketplace.activate
    bank_account_mock = StripeMock::Data.mock_bank_account
    bank_account_token = @stripe_helper.generate_bank_token(bank_account_mock)
    bank_account = Stripe::BankAccount.new(external_account: bank_account_token)

    Stripe::Account.stub :retrieve, account do
      account.external_accounts.stub :retrieve, bank_account do
        account.stub :save, bank_account do
          assert_equal @bank_account_registered.sync.to_json, "{}"
        end
      end
    end
  end

end
