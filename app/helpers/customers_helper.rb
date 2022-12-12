module CustomersHelper
	def get_bg_color_of_status balance
		balance.pending? ? "pending_balance" : "no_dues_balance"
	end
end
	# def display_amount balance
	# 	if balance.nil?
	# 		"<p class='zero_bal'>0</p>".html_safe
	# 	elsif balance.advance_amount.present?
	# 		"<p class='adv_amt'>+ #{balance.advance_amount}/-</p>".html_safe
	# 	else
	# 		"<p class='due_amt'>- #{balance.due_amount}/-</p>".html_safe
	# 	end
	# end



