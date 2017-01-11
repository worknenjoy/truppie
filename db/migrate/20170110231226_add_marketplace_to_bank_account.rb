class AddMarketplaceToBankAccount < ActiveRecord::Migration
  def change
    add_reference :bank_accounts, :marketplace, index: true, foreign_key: true
  end
end
