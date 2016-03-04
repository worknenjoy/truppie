class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :url
      t.string :caption
      t.references :category, index: true, foreign_key: true
      t.references :tags, index: true, foreign_key: true
      t.references :where, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
