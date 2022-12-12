class CreateBillings < ActiveRecord::Migration[5.2]
  def change
    create_table :billings do |t|
    	t.integer :customer_id
    	t.integer :bill_no
    	t.integer :amount
    	t.datetime :due_date
    	t.string :status
      t.integer :discount_amount
      t.boolean :receipt, default: false
      t.integer :organization_id
      t.integer :final_amount
      t.datetime :booking_date
      t.integer  :advance_amount
      t.integer  :total_paid_amount
      t.integer  :balance_id
      t.timestamps
    end
  end
end
