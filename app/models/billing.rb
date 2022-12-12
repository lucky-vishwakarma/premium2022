class Billing < ApplicationRecord
	# Association
	belongs_to :customer, optional: true
	belongs_to :organization, optional: true
	has_many :carts
	has_many :balances
	accepts_nested_attributes_for :carts, :reject_if => proc { |att| att[:item_id].blank? || att[:quantity].blank? || att[:amount].blank?}, :allow_destroy => true
	ransack_alias :customer, :phone
	# Validation
	validates :bill_no, presence: true
	validates :bill_no, uniqueness: { scope: :organization_id, message: "already exist in this organization" }
	# Scope
	scope :pending, -> { where('status = ?', "pending")}
	scope :complete, -> { where('status = ?', "complete")}
	scope :delivered, -> { where('status = ?', "delivered")}

	before_create :assign_status
	after_create :update_amount

	# Delegates
	delegate :name, to: :customer
	delegate :phone, to: :customer
    default_scope {order('id DESC')}


	def assign_status
		self.status = "pending"
	end

	def update_amount
		cart_total_amount = self.carts.sum(:amount)
		self.update_attributes(amount: cart_total_amount, final_amount: cart_total_amount)
	end

	def update_organization params
		self.update_attributes(bill_no: params[:bill_no], organization_id: params[:organization_id])
		self
	end

	def organization_exist?
		self.organization_id.present? && self.bill_no.present?
	end

	def customer_number_exist?
		customer.phone.present?
	end

	def send_order_confirm_sms
		if customer_number_exist?	
			message = "Your order no.#{self.bill_no} has been received. Will be delivered #{self.due_date.strftime("%d/%m/%Y")} amount Rs.#{self.final_amount}. Thank you for using PREMIUM DRY CLEANERS"
			Sms.send_sms(message, self.phone)
		end
	end

	def send_order_complete_sms
		if final_amount.present?
			message = "Your order no. #{self.bill_no} has been completed.please collect as soon as possible. Thank you for using PREMIUM DRY CLEANERS"
			Sms.send_sms(message, phone)	
		end
	end

	def create_customer phone, name
		c = Customer.find_by(phone: phone)
		if c.present?
			self.customer_id =  c.id
		else
			c = Customer.create(name: name, phone: phone)
			self.customer_id = c.id
		end
	end

	def complete?
		self.status == "complete"
	end

	def delivered?
		self.status == "delivered"
	end

	def get_phone
		self.persisted? ? self.phone : ""
	end

	def get_name
		self.persisted? ? self.name : ""
	end

	def update_customer_info cust_phone, cust_name
		self.customer.update_attributes(phone: cust_phone, name: cust_name)
	end

	def update_billing total_paid_amount
		if total_paid_amount.to_i > self.final_amount
			advance = total_paid_amount.to_i - self.final_amount
			self.balances.create(customer_id: customer_id, advance_amount: advance, due_amount: 0, status: "pending")
		elsif total_paid_amount.to_i < self.final_amount			
			due = self.final_amount - total_paid_amount.to_i
			self.balances.create(customer_id: customer_id, due_amount: due, advance_amount: 0, status: "pending")
		end
		self.update_attributes(status: "delivered", due_date: Date.today, total_paid_amount: total_paid_amount)
	end

	def balance
		self.balance_id.present? ? customer.balances.find_by(id: self.balance_id) : nil
	end
	def update_all_parameter
		total_cart_amounts = self.carts.sum(:amount)
		temp_final_amount = total_cart_amounts - self.advance_amount.to_i - self.discount_amount.to_i
	    self.update_attributes(receipt: false,	final_amount: temp_final_amount, amount: total_cart_amounts)
		get_adjust_balance(balance) if balance.present?	    
	end

	def update_final_billing_with_advance_amount params
		self.discount_amount = params[:discount_amount].to_i
	    self.advance_amount = params[:advance_amount].to_i
	    self.final_amount = self.amount - self.discount_amount - self.advance_amount
	    self.receipt = true
	    self.save
	    if params[:balance_id].present? # at this time this is bill number
	    	bill = Billing.find_by(bill_no: params[:balance_id])
		    pre_balance = self.customer.balances.pending.find_by(billing_id: bill.id)
		   	get_adjust_balance(pre_balance) if pre_balance.present?	 
		elsif balance.present?
			get_adjust_balance(balance)
		end 
	end

	def adjust_balance?
		self.customer.balances.pending.present? ? true : false
	end

	def adjust_balance
		bal = customer.balances.find_by(adjust_billing_id: self.id)
		bal.present? ? bal : false
	end

	def get_adjust_balance pre_balance
		if pre_balance.present?
			if pre_balance.due_amount > 0
				final_bal = self.final_amount + pre_balance.due_amount.to_i
			elsif pre_balance.advance_amount > 0
				final_bal = self.final_amount - pre_balance.advance_amount.to_i
			end
			self.update_attributes(final_amount: final_bal, balance_id: pre_balance.id)
			pre_balance.update_billing_status(self.id)
		end
	end

	def get_balance_amount_after_paid_final_amount
		if self.final_amount > self.total_paid_amount
			"<span class='due_amt'>(- #{final_amount - total_paid_amount})</span>".html_safe
		else
			"<span class='adv_amt'>(+ #{total_paid_amount - final_amount})</span>".html_safe
		end
	end

	def bill_no_of_balance_amount
		balance.billing
	end

	def get_total_final_amount
		total_paid_amount.present? ? total_paid_amount : final_amount
	end

	def self.to_csv(options = {}, billing_attributes = ["name", "phone", "bill_no", "amount", "discount_amount", "booking_date", "due_date"], customer_attributes=["name","phone" ])
    # attributes = %w{id name}
    CSV.generate(options) do |csv|
    	csv.add_row billing_attributes
    	all.each do |foo|
	      if foo.customer
	        values = foo.customer.attributes.slice(*customer_attributes).values 
	      end
	      values += foo.attributes.slice(*billing_attributes).values
	      csv.add_row values
	    end
    end
  end
	
end



