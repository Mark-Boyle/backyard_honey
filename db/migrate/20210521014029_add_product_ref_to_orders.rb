class AddProductRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :product, null: false, foreign_key: true
  end
end
