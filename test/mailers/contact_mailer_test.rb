require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test "send a contact" do
     params = {:name => 'Alexandre Magno',:subject => "opinion", :email => 'alexanmtz@gmail.com', :body => 'hi'}
     mail = ContactMailer.send_form(params)
     
     ContactMailer.send_form(params).deliver_now
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['alexanmtz@gmail.com'], mail.from
     assert_equal ['ola@truppie.com'], mail.to
     assert_equal "#{params[:name]} enviou \n #{params[:body]}", mail.body.raw_source
     
   end
end
