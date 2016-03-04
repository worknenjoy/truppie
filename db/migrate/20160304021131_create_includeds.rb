class CreateIncludeds < ActiveRecord::Migration
  def change
    create_table :includeds do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
