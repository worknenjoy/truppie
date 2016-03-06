class CreateJoinTableTourWhere < ActiveRecord::Migration
  def change
    create_join_table :tours, :wheres do |t|
       t.index [:tour_id, :where_id]
       t.index [:where_id, :tour_id]
    end
  end
end
