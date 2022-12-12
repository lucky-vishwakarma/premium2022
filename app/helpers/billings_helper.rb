module BillingsHelper
	def get_status status
		case status
			when "pending"
			  return "complete" 
			when "complete"
			  return "delivered"
			when "canceled"
			  return "reorder"
			else
				return "done"
		end
	end

	def get_icon status
		case status
			when "pending"
			  return "fa fa-ellipsis-h" 
			when "complete"
			  return "fa fa-check-circle-o"
			when "delivered"
			  return "fa fa-handshake-o"
			else
				return "fa fa-close"
		end
	end

	def billing_title billing
		billing.persisted? ? "EDIT BILLING" : "NEW BILLING"
	end

	def submit_tag_title billing
		billing.persisted? ? "UPDATE" : "SUBMIT"
	end

	def billing_cancel?(billing)
		billing.status == "canceled" ? "cancel" : ""
	end

	def bal_status billing
		if billing.customer.balances.present?
			bal = billing.customer.balances.last
			balance = (bal.status == "pending" || bal.adjust_billing_id == billing.id) ? bal : nil
			if balance.present?
				balance.get_balance_status
			end
		end

	end

	def balance_status(billing)
		bal_status(billing).present? ? (bal_status(billing).first[0].to_s.titleize) : "" 
	end

	def balance_amount(billing)		
		bal_status(billing).present? ? positiv_negetive_bal(billing) : 0
	end

	def positiv_negetive_bal(billing)
		if bal_status(billing).first[0] == :due_amount
			"+#{bal_status(billing).first[1].to_i}/-"
		else
			"-#{bal_status(billing).first[1].to_i}/-"
		end
	end

	def get_booking_date(billing)
		billing.booking_date.present? ? billing.booking_date : Date.today
	end

	def get_adjust_balance_status balance
		if balance.advance_amount > 0
			"-#{balance.advance_amount}/-"
		else
			"+#{balance.due_amount}/-"
		end
	end

	def billing_sum billings, status
		if status == "delivered"
			billings.to_a.sum { |e| e.total_paid_amount.to_i }
		else
			billings.to_a.sum { |e| e.final_amount.to_i }
			# billings.map{|b| b.final_amount}.sum
		end
	end

	def advance_sum billings
		billings.to_a.sum { |e| e.advance_amount.to_i }
	end
end
