class CreateJoinTableAttractionsToWhere < ActiveRecord::Migration
  def change
    create_join_table :wheres, :attractions do |t|
       t.index [:where_id, :attraction_id]
       t.index [:attraction_id, :where_id]
    end
  end
end
