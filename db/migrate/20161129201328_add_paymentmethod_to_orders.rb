class AddPaymentmethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method, :string, default: "CREDIT_CARD"
  end
end
