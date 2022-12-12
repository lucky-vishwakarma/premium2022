class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
    	t.integer :billing_id
    	t.integer :item_id
    	t.integer :quantity
    	t.integer :amount
      t.text   :remark
      t.integer :service_id
      t.timestamps
    end
  end
end
