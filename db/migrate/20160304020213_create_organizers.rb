class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.string :name
      t.string :logo
      t.string :cover
      t.string :description
      t.references :member, index: true
      t.integer :rating
      t.references :user, index: true, null: false
      t.references :where, index: true
      t.string :email
      t.string :website
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :phone

      t.timestamps null: false
    end
  end
end
