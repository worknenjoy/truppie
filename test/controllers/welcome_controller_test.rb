
require 'test_helper'
require 'json'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:alexandre)

    set_organizer = {
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

     @organizer = Organizer.create!(set_organizer)
  end

  test 'when a guide is online redirect to profile guide page' do
    get :organizer
    assert_redirected_to profile_edit_organizer_path(@organizer)
  end
end
