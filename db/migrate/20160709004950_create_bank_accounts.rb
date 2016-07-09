class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :bankNumber
      t.string :agencyNumber
      t.string :agencyCheckNumber
      t.string :accountNumber
      t.string :accountCheckNumber
      t.string :type
      t.string :doc_type
      t.string :doc_number
      t.string :fullname
      t.references :organizer, index: true, foreign_key: true
      t.string :uid

      t.timestamps null: false
    end
  end
end
