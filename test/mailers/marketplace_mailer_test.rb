require 'test_helper'

class MarketplaceMailerTest < ActionMailer::TestCase
  
  test "send email when activate a new marketplace" do
     
     mail = MarketplaceMailer.activate(Organizer.last).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["organizer@mail.com"], mail.to
     assert_equal "Sua carteira da Truppie foi ativada com sucesso", mail.subject
   end
   
   test "send email when a bank account was activated" do
     o = organizers(:mkt)
     
     mail = MarketplaceMailer.activate_bank_account(o).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part

     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Sua conta bancária foi cadastrada na Truppie com sucesso", mail.subject
   end
   
   test "send email when a transfer was requested" do
     o = organizers(:mkt)
     
     mail = MarketplaceMailer.transfer(o, "R$ 100,00", "Nice date format").deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part

     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ['ola@truppie.com'], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Uma nova transferência para sua conta foi realizada", mail.subject
   end
   
   test "update a account with details" do
     o = organizers(:mkt)
     account = o.marketplace
     mail = MarketplaceMailer.update(o).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Sua carteira da Truppie foi atualizada com sucesso", mail.subject
     
   end
   
   test "update a account with missing bank details" do
     o = organizers(:mantiex)
     account = o.marketplace
     mail = MarketplaceMailer.update(o).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["MyString"], mail.to
     assert_equal "Sua carteira da Truppie foi atualizada com sucesso", mail.subject
     
   end
   
   test "activate account with missing bank details" do
     o = organizers(:mantiex)
     account = o.marketplace
     mail = MarketplaceMailer.activate(o).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["MyString"], mail.to
     assert_equal "Sua carteira da Truppie foi ativada com sucesso", mail.subject
     
   end
   
   test "activate a account with details" do
     o = organizers(:mkt)
     account = o.marketplace
     mail = MarketplaceMailer.activate(o).deliver_now
     
     #puts ActionMailer::Base.deliveries[0].html_part
     
     assert_not ActionMailer::Base.deliveries.empty?
     assert_equal ["ola@truppie.com"], mail.from
     assert_equal ["mail@foo.com"], mail.to
     assert_equal "Sua carteira da Truppie foi ativada com sucesso", mail.subject
     
   end

  test "send mail with authorization to enable external payments" do
    m = Marketplace.last
    m.payment_types.create({
        type_name: 'pagseguro',
        email: 'payment@pagseguro.com',
        auth: '123'
    })
    mail = MarketplaceMailer.request_app_auth(m).deliver_now

    #puts ActionMailer::Base.deliveries[0].html_part

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ["ola@truppie.com"], mail.from
    assert_equal ["payment@pagseguro.com"], mail.to
    assert_equal "Autorização para usar o #{m.payment_types.first.type_name} nas suas truppies", mail.subject

  end
   
end
