class AddJoinTableWhereToGuidebook < ActiveRecord::Migration
  def change
    create_join_table :wheres, :guidebooks do |t|
       t.index [:where_id, :guidebook_id]
       t.index [:guidebook_id, :where_id]
    end
  end
end
