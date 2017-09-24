class AddWhereToBackground < ActiveRecord::Migration
  def change
    add_reference :backgrounds, :where, index: true, foreign_key: true
  end
end
