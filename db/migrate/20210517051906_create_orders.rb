class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.decimal :total_price, precision: 5, scale: 2
      t.date :order_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
