class AddJoinTablePackageGuidebook < ActiveRecord::Migration
  def change
    create_join_table :packages, :guidebooks do |t|
      t.index [:package_id, :guidebook_id]
      t.index [:guidebook_id, :package_id]
    end
  end
end
