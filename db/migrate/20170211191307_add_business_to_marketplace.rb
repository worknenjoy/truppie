class AddBusinessToMarketplace < ActiveRecord::Migration
  def change
    add_column :marketplaces, :business, :boolean, default: false
  end
end
