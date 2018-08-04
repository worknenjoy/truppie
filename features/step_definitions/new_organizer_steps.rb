Given(/^I have a registered organizer$/) do
  email = 'teste@teste.com'
  password = 'teste'
  user = User.new(:email => email, :password => password, :password_confirmation => password).save!
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
  expect(page).to have_content("Morro dois irmaos")
end


And(/^I click in register guide$/) do
  click_link "Cadastrar negócio"
end


And(/^I fill the guide information$/) do
  fill_in "organizer[name]", :with => "Luisa Bastos"
  fill_in "organizer[email]", :with => "amanda.lssc@gmail.com"
  fill_in "organizer[website]", :with => "www.teste.com"
  fill_in "organizer[description]", :with => "Isso é um teste de novo guia"
  click_link "Continuar"
  fill_in "search", :with => "Minas Gerais, Brazil"
  click_link "Continuar"
  fill_in "organizer[phone]", :with => "15997168035"
  fill_in "organizer[instagram]", :with => 'instagram.com'
  click_link "Continuar"
  attach_file('organizer[picture]', File.join(Rails.root, 'features', 'upload-files', 'image.jpg'))
  click_link "Continuar"
end

And(/^I click in finish$/) do
  click_button "Concluir"
end

Then(/^I see the guide profile page$/) do
  expect(page).to have_content("Meu perfil")
end

Then(/^I should see an organizer$/) do
  expect(page).to have_content("Minhas truppies")
end

Given(/^I create an user account$/) do
  fill_in "organizer[name]", :with => "Luisa Bastos"
  fill_in "organizer[email]", :with => "amanda.lssc@gmail.com"
  fill_in "organizer[password]", :with => "123456789"
  fill_in "organizer[password_confirmation]", :with => "123456789"
  fill_in "organizer[website]", :with => "www.teste.com"
  fill_in "organizer[description]", :with => "Isso é um teste de novo guia"
  click_link "Continuar"
  fill_in "search", :with => "Minas Gerais, Brazil"
  click_link "Continuar"
  fill_in "organizer[phone]", :with => "15997168035"
  fill_in "organizer[instagram]", :with => 'instagram.com'
  click_link "Continuar"
  attach_file('organizer[picture]', File.join(Rails.root, 'features', 'upload-files', 'image.jpg'))
  click_link "Continuar"
end
