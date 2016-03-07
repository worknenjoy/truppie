require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
   test "one Organizer" do
     assert_equal 1, Organizer.count
   end
   
   test "organizer has two members" do
     assert_equal 2, Organizer.last.members.size
     assert_equal 'laurinha@email.com', Organizer.last.members.first.user.email
     assert_equal 'alexandre@email.com', Organizer.last.members.last.user.email
   end
   
end
