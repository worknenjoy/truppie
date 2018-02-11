 include Devise::TestHelpers
 require 'test_helper'
 begin
   require 'minitest/mock'
   require 'minitest/unit'
   MiniTest.autorun
 rescue LoadError => e
   raise e unless ENV['RAILS_ENV'] == "production"
 end
 
 class OrganizersControllerTest < ActionController::TestCase
   self.use_transactional_fixtures = true
   
   setup do
     StripeMock.start
     sign_in users(:alexandre)
     @organizer_ready = organizers(:utopicos)
     @mkt = organizers(:mkt)
     @guide_mkt_validated = organizers(:guide_mkt_validated)
     @organizer = {
       name: "Utópicos mundo afora",
       description: "uma agencia utopica",
       email: "utopicos@gmail.com",
       website: "http://website",
       facebook: "a facebook",
       twitter: "a twitter",
       instagram: "a instagram",
       phone: "a phone",
       user_id: users(:alexandre).id
     }
     
   end
   


    test "should send notification to organizer for default" do
     @organizer = Organizer.last
     @organizer.update_attributes(:mail_notification => false)
     assert_not ActionMailer::Base.deliveries.empty?
     
     assert_difference('Organizer.count') do
       post :create, organizer: @organizer
     end
     assert ActionMailer::Base.deliveries.empty?
     assert_equal flash[:notice], "Sua conta como guia foi criada com sucesso"
     assert_redirected_to organizer_path(assigns(:organizer))
    end
 end
