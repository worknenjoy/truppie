class AddParentToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :parent, index: true, foreign_key: true
  end
end
