class AddOwnIdToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :own_id, :string
  end
end
