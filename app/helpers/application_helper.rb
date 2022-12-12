module ApplicationHelper
	def is_active_controller? controller_name, action_name
		params[:controller] == controller_name && action_name.include?(params[:action]) ? "active" : ""
	end
end
