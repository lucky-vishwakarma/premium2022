module AttendancesHelper
	def get_payment_color emp_record
		emp_record.pending? ? "complete btn btn-primary btn-xs bg_complete" : " btn btn-primary btn-xs bg_delivered"
	end

	def tab_pay_color emp_record
		emp_record.pending? ? "complete btn btn-primary btn-xs bg_complete" : "delivered btn btn-primary btn-xs bg_delivered"
	end

	def get_attendance_url employee

	end
end
