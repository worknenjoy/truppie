class CreateMarketplaces < ActiveRecord::Migration
  def change
    create_table :marketplaces do |t|
      t.references :organizer, index: true, foreign_key: true
      t.references :bank_account, index: true, foreign_key: true
      t.boolean :active
      t.string :person_name
      t.string :person_lastname
      t.string :document_type
      t.string :document_number
      t.string :id_number
      t.string :id_type
      t.string :id_issuer
      t.string :id_issuerdate
      t.date :birthDate
      t.string :street
      t.string :street_number
      t.string :complement
      t.string :district
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :country
      t.string :token
      t.string :account_id
      t.timestamps null: false
    end
  end
end
