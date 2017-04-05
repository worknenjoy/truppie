class CreateTourPictures < ActiveRecord::Migration
  def change
    create_table :tour_pictures do |t|
      t.attachment :photo
      t.references :tour, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
