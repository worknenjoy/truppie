class AddCompanyAddressToMarketplace < ActiveRecord::Migration
  def change
    add_column :marketplaces, :company_city, :string
    add_column :marketplaces, :company_country, :string
    add_column :marketplaces, :company_street, :string
    add_column :marketplaces, :compcompany_complement, :string
    add_column :marketplaces, :company_state, :string
    add_column :marketplaces, :company_zipcode, :string
    add_column :marketplaces, :terms_accepted, :date
    add_column :marketplaces, :terms_ip, :string
  end
end
