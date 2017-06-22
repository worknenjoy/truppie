class CreateJoinTableMarketplacesPaymentTypes < ActiveRecord::Migration
  def change
    create_join_table :marketplaces, :payment_types do |t|
       t.index [:marketplace_id, :payment_type_id], name: 'marketplace_payment'
       t.index [:payment_type_id, :marketplace_id], name: 'payment_marketplace'
    end
  end
end
