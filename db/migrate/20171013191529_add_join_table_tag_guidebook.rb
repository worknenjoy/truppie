class AddJoinTableTagGuidebook < ActiveRecord::Migration
  def change
    create_join_table :tags, :guidebooks do |t|
      t.index [:tag_id, :guidebook_id]
      t.index [:guidebook_id, :tag_id]
    end
  end
end
