Given(/^I have a registered tour$/) do
  #puts Tour.all.inspect
end

Given(/^I am a registered user$/) do
  email = 'testing@man.net'
  password = 'secretpass'
  user = User.new(:email => email, :password => password, :password_confirmation => password).save!
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end

When(/^I go to the homepage$/) do
  visit root_path
end

When(/^I click on a tour$/) do
  tour_id = Tour.last.id
  click_link "twPc-bg-#{tour_id}"
end

And(/^I click confirm reservation$/) do
  click_link "Reservar agora"
end

And(/^I fill the credit card details and confirm$/) do
  fill_in "fullname", :with => "Alexandre Magno Teles Zimerer"
  fill_in "birthdate", :with => "06/10/1982"
  fill_in "street", :with => "Rua x"
  fill_in "complement", :with => "complement"
  fill_in "city", :with => "Any City"
  fill_in "state", :with => "Any State"
  fill_in "country", :with => "Any Country"
  fill_in "zipcode", :with => "22640-338"
  fill_in "number", :with => "4242424242424242"
  fill_in "expiration_month", :with => "10"
  fill_in "expiration_year", :with => "22"
  fill_in "cvc", :with => "123"
  click_buttom "Confirmar Reserva"
end

Then(/^I should see a tour$/) do
  expect(page).to have_content("Morro dois irmaos")
end

Then(/^I see the confirmation page$/) do
  expect(page).to have_content("Sua presença foi confirmada")
end