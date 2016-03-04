class CreateNonincludeds < ActiveRecord::Migration
  def change
    create_table :nonincludeds do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
