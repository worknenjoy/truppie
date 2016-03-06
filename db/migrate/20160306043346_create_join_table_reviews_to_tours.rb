class CreateJoinTableReviewsToTours < ActiveRecord::Migration
  def change
    create_join_table :reviews, :tours do |t|
       t.index [:review_id, :tour_id]
       t.index [:tour_id, :review_id]
    end
  end
end
