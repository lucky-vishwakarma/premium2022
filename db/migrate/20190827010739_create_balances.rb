class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
    	t.integer :customer_id
    	t.integer :billing_id
    	t.integer :due_amount
    	t.integer :advance_amount
    	t.string  :status
      t.integer :adjust_billing_id
      	t.timestamps
    end
  end
end
