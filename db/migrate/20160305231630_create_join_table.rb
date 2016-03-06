class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :tours, :tags do |t|
       t.index [:tour_id, :tag_id]
       t.index [:tag_id, :tour_id]
    end
  end
end
