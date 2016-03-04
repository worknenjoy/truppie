class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.string :name
      t.string :description
      t.references :members, index: true, foreign_key: true
      t.number :rating
      t.references :user, index: true, foreign_key: true
      t.references :where, index: true, foreign_key: true
      t.string :email
      t.string :website
      t.string :facebook
      t.string :twitter
      t.references :tags, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
