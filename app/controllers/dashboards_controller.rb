class DashboardsController < ApplicationController

	def index
		@title = "sdasA"
	end

	def welcome
		render layout: "devise"
	end
end
