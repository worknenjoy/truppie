class AddBankInfoToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :active, :boolean
    add_column :organizers, :person_name, :string
    add_column :organizers, :person_lastname, :string
    add_column :organizers, :document_type, :string
    add_column :organizers, :document_number, :string
    add_column :organizers, :id_type, :string
    add_column :organizers, :id_number, :string
    add_column :organizers, :id_issuer, :string
    add_column :organizers, :id_issuerdate, :string
    add_column :organizers, :birthDate, :string
    add_column :organizers, :street, :string
    add_column :organizers, :street_number, :string
    add_column :organizers, :complement, :string
    add_column :organizers, :district, :string
    add_column :organizers, :zipcode, :string
    add_column :organizers, :city, :string
    add_column :organizers, :state, :string
    add_column :organizers, :country, :string
    add_column :organizers, :token, :string
    add_column :organizers, :account_id, :string
  end
end
