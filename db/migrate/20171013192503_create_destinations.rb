class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :downloaded

      t.timestamps null: false
    end
  end
end
