class CreateJoinTableLanguagesToGuidebooks < ActiveRecord::Migration
  def change
    create_join_table :languages, :guidebooks do |t|
      t.index [:language_id, :guidebook_id]
      t.index [:guidebook_id, :language_id]
    end
  end
end
