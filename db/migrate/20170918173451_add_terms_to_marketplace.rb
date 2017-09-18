class AddTermsToMarketplace < ActiveRecord::Migration
  def change
    add_column :marketplaces, :terms, :boolean, default: false
  end
end
