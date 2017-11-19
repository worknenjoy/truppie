require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
   
   def setup
     StripeMock.start
     @stripe_helper = StripeMock.create_test_helper
     @organizer = organizers(:utopicos)
     @mkt = organizers(:mkt)
     @mantiex = organizers(:mantiex)
   end
   
   teardown do
    StripeMock.stop
   end
   
   test "one Organizer" do
     assert_equal 4, Organizer.count
   end
   
   test "organizer has two members" do
     assert_equal 2, Organizer.last.members.size
     assert_equal 'laurinha.sette@gmail.com', Organizer.last.members.first.user.email
     assert_equal 'alexanmtz@gmail.com', Organizer.last.members.last.user.email
   end
   
   test "organizer has an account not active by default" do
     organizer_account = organizers(:utopicos)
     assert_equal organizer_account.market_place_active, false
   end
   
   test "organizer has an account active with a marketplace account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
   end

   test "organizer has percentage" do
     organizer_account_active = organizers(:mkt)
     organizer_account_active.update_attributes({:percent => 10})
     assert_equal organizer_account_active.percent, 10
   end
   
   test "organizer with an active marketplace should have mkt account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
     assert_equal organizer_account_active.marketplace.active, true
   end
   
   test "organizer with an active marketplace should access one active bank account" do
     organizer_account_active = organizers(:mkt)
     assert_equal organizer_account_active.market_place_active, true
     assert_equal organizer_account_active.marketplace.bank_accounts.last.active, true
     assert_equal organizer_account_active.marketplace.bank_accounts.where(:active => true).count, 1
   end
   
   test "organizer should not have a balance if has no marketplace active" do
     assert_equal @mantiex.balance, false       
   end

   test "organizer fill all information needed" do
     @organizer.update_attributes({:fulldesc => 'some full desc', :instagram => 'the instagram', :picture_file_name => 'some picture file name'})
     assert_equal @organizer.verified?, true
     assert_equal @organizer.missing[0], "cover"
   end
   
   test "display just published organizers" do
     @organizer.status = 'P'
     @organizer.save()
     
     is_inside = false
     
     Organizer.publisheds.each do |o|
       if o.name == @organizer.name
         is_inside = true
       end
     end
     
     assert is_inside, "is inside!"
   end

   test "organizer has clients" do

     @tour = tours(:morro)
     @order_one = orders(:one)
     @order_two = orders(:two_reservation)

     @tour.orders << @order_one
     @tour.orders << @order_two
     @tour.save

     assert_equal @tour.organizer.clients, [@order_one.user, @order_two.user]

   end
   
   test "organizer should have a balance if has a marketplace active" do
     skip("balance after has order working")
     #body = {"unavailable"=>[{"amount"=>0, "currency"=>"BRL"}], "future"=>[{"amount"=>0, "currency"=>"BRL"}], "current"=>[{"amount"=>44592168, "currency"=>"BRL"}]}
     #FakeWeb.register_uri(:get, "https://sandbox.moip.com.br/v2/balances", :body => body.to_json, :status => ["201", "Success"]
     assert_equal @mkt.balance, {"unavailable"=>[{"amount"=>0, "currency"=>"BRL"}], "future"=>[{"amount"=>0, "currency"=>"BRL"}], "current"=>[{"amount"=>44592168, "currency"=>"BRL"}]}
     assert_equal @mkt.balance["future"][0]["amount"], 0       
   end



end
