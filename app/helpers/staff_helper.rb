module StaffHelper

	def get_form_url staff
		staff.persisted? ?  employee_path(staff) : employees_path
	end
end
