require 'test_helper'

class OrganizerMailerTest < ActionMailer::TestCase
  test "activate a new organizer" do
     o = organizers(:mkt)
     mail = OrganizerMailer.notify(o, "activate").deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     #assert_equal ActionMailer::Base.deliveries[0].html_part.to_s.include?('criada'), true
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Olá #{o.name}, sua conta na Truppie foi criada!", mail.subject
     
  end
  
  test "update a new organizer" do
     o = organizers(:mkt)
     mail = OrganizerMailer.notify(o, "update").deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     #assert_equal ActionMailer::Base.deliveries[0].html_part.to_s.include?('atualizada'), true
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Olá #{o.name}, sua conta na Truppie foi atualizada!", mail.subject
     
  end

  test "new follower" do
     o = organizers(:mkt)
     u = users(:laura)
     mail = OrganizerMailer.new_follower(o, u).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     #assert_equal ActionMailer::Base.deliveries[0].html_part.to_s.include?('atualizada'), true
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Olá #{o.name}, o usuário #{u.name} começou a te seguir", mail.subject
     
  end
  
end
