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
   
end
