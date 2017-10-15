class AddJoinTableCommentsToGuidebook < ActiveRecord::Migration
  def change
    create_join_table :comments, :guidebooks do |t|
      t.index [:comment_id, :guidebook_id]
      t.index [:guidebook_id, :comment_id]
    end
  end
end
