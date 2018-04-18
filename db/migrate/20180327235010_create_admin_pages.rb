# Start migration Admin Pages
class CreateAdminPages < ActiveRecord::Migration
  def self.up
    create_table :admin_pages do |t|
      t.string :namespace
      t.string :lang
      t.text   :body

      t.timestamps null: false
    end
    add_index :admin_pages, [:namespace]
  end

  def self.down
    drop_table :admin_pages
  end
end
