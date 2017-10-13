class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.references :comment, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
