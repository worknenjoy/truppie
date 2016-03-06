class CreateJoinTableConfirmedToTours < ActiveRecord::Migration
  def change
    create_join_table :confirmeds, :tours do |t|
       t.index [:confirmed_id, :tour_id]
       t.index [:tour_id, :confirmed_id]
    end
  end
end
