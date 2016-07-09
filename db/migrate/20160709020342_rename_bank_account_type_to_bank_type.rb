class RenameBankAccountTypeToBankType < ActiveRecord::Migration
  def change
    rename_column :bank_accounts, :type, :bankType
  end
end
