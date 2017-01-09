require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
   test "one Organizer" do
     assert_equal 3, Organizer.count
   end
   
   test "organizer has two members" do
     assert_equal 2, Organizer.last.members.size
     assert_equal 'laurinha.sette@gmail.com', Organizer.last.members.first.user.email
     assert_equal 'alexanmtz@gmail.com', Organizer.last.members.last.user.email
   end
   
   test "organizer has an account not active by default" do
     organizer_account = organizers(:utopicos)
     assert_equal organizer_account.market_place_active, false
   end
   
   test "organizer has an account active with a marketplace account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
   end
   
   test "organizer with an active marketplace should have mkt account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
     assert_equal organizer_account_active.marketplace.active, true
   end
   
   test "organizer with an active marketplace should access one active bank account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
     assert_equal organizer_account_active.marketplace.bank_accounts.last.active, true
     assert_equal organizer_account_active.marketplace.bank_accounts.where(:active => true).count, 1
   end   
end
