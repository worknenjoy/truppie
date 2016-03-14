require 'test_helper'

class TourTest < ActiveSupport::TestCase
  test "one tour created" do
     assert_equal 1, Tour.count
   end
   
   test "a user that create the tour" do
     assert_equal 'laurinha@email.com', Tour.last.user.email
   end
   
   test "a organizer for the tour" do
     assert_equal "Utopicos Mundo Afora", Tour.last.organizer.name
   end
   
   test "the right place for the tour" do
     assert_equal "Rio", Tour.last.where.name
   end
   
   test "one category" do
     assert_equal "Trekking", Tour.last.category.name
   end
   
   test "many tags" do
     assert_equal 3, Tour.last.tags.size
   end
   
   test "many attractions" do
     assert_equal 2, Tour.last.attractions.size
   end
   
   test "confirmed" do
     assert_equal 0, Tour.last.confirmeds.size
   end
   
   test "confirmed availability soldout for infinite availability" do
     assert_equal 0, Tour.last.confirmeds.size
     assert_equal false, Tour.last.soldout?
   end
   
   test "confirmed availability number" do
     Tour.last.confirmeds.create(user: User.last)
     assert_equal 2, Tour.last.available
   end
   
   test "confirmed availability soldout still possible" do
     Tour.last.confirmeds.create(user: users(:laura))
     Tour.last.confirmeds.create(user: users(:alexandre))
     assert_equal false, Tour.last.soldout?
   end
   
   test "confirmed availability soldout not possible" do
     Tour.last.confirmeds.create(user: users(:laura))
     Tour.last.confirmeds.create(user: users(:alexandre))
     Tour.last.confirmeds.create(user: users(:fulano))
     Tour.last.confirmeds.create(user: users(:ciclano))
     assert_equal true, Tour.last.soldout?
   end
   
   test "languages" do
     assert_equal 2, Tour.last.languages.size
   end
   
   test "reviews" do
     assert_equal 2, Tour.last.reviews.size
   end
   
   test "friendly duration" do
      assert_equal "3 minutes", Tour.last.duration
   end
   
   test "a friendly duration more accurated test" do
     Tour.last.update_attribute(:start, '2016-03-01 23:56:31')
     Tour.last.update_attribute(:end, '2018-03-01 23:56:31')
     assert_equal "about 2 years", Tour.last.duration
   end
   
   test "a tour friendly difficult measure" do
     easytour = Tour.last.level
     assert_equal "easy", easytour
   end
   
   test "a price in real" do
     price = Tour.last.price
     assert_equal "<small>R$</small> 40", price
   end
   
end
