class RemoveWhereIdFromTours < ActiveRecord::Migration
  def change
    remove_reference :tours, :where, index: true, foreign_key: true
  end
end
