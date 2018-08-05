class AddPackageToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :package, index: true, foreign_key: true
  end
end
