class RemoveOrderRefFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_reference :products, :order, null: false, foreign_key: true
  end
end
