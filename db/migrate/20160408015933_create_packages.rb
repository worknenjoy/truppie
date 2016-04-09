class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :name
      t.integer :value
      t.text :included, array: true, default: []
      #t.references :tour, index: true

      t.timestamps null: false
    end
  end
end
