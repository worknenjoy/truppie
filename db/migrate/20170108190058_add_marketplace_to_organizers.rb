class AddMarketplaceToOrganizers < ActiveRecord::Migration
  def change
    add_reference :organizers, :marketplace, index: true
    add_foreign_key :organizers, :marketplaces
  end
end
