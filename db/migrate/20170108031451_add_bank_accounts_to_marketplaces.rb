class AddBankAccountsToMarketplaces < ActiveRecord::Migration
  def change
    create_join_table :marketplaces, :bank_accounts do |t|
      t.index [:marketplace_id, :bank_account_id], name: 'mktplace_id_bank_account'
      t.index [:bank_account_id, :marketplace_id], name: 'bank_account_id_mktplace'
    end
  end
end
