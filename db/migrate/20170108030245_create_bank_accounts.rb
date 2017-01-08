class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :bank_number
      t.string :agency_number
      t.string :agency_check_number
      t.string :account_number
      t.string :account_check_number
      t.string :bank_type
      t.string :doc_type
      t.string :doc_number
      t.string :fullname
      t.boolean :active

      t.timestamps null: false
    end
  end
end
