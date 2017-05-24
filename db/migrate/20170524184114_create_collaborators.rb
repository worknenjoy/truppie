class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.references :marketplace, index: true, foreign_key: true
      t.integer :percent
      t.string :transfer

      t.timestamps null: false
    end
  end
end
