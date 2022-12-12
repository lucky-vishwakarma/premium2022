class Balance < ApplicationRecord
	belongs_to :customer, optional: true
	belongs_to :billing, optional: true
	scope :pending, -> {where("status = ?", "pending")}
	
	default_scope {order('id DESC')}
	def get_balance_status
		if self.due_amount?
			{due_amount: self.due_amount}
		else
			{advance_amount: self.advance_amount}
		end
	end

	def update_billing_status billing_id
		self.update_attributes(adjust_billing_id: billing_id, status: "No Dues")
	end

	def pending?
		self.status == "pending" ? true : false
	end

	def get_bill_number
		Billing.find_by(id: self.billing_id).bill_no
	end

	def get_adjust_billing_number
		Billing.find_by(id: self.adjust_billing_id).bill_no if self.adjust_billing_id.present?
	end
end
