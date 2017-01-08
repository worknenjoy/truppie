require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
   test "one Organizer" do
     assert_equal 2, Organizer.count
   end
   
   test "organizer has two members" do
     assert_equal 2, Organizer.last.members.size
     assert_equal 'laurinha.sette@gmail.com', Organizer.last.members.first.user.email
     assert_equal 'alexanmtz@gmail.com', Organizer.last.members.last.user.email
   end
   
   test "organizer has a account activate" do
     organizer_with_account_active = organizers(:utopicos)
     assert_equal organizer_with_account_active.marketplace_active, false
   end
end
