class ApplicationController < ActionController::Base
	layout :layout_by_resource
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def get_organizations
    @organizations = Organization.all
  end

  
  def check_admin_user
    redirect_to new_user_session_path unless current_user.admin?
  end


  	private

  	def layout_by_resource
    	if devise_controller?
      		"devise"
    	else
      		"application"
    	end
  	end

  	protected  
    def after_sign_in_path_for(resource)
    	billings_path
    end
end
