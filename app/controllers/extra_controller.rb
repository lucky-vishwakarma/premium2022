class ExtraController < ApplicationController

	def index
		@items = Item.all
	end

	def create_item
		item = Item.new(name: params[:item][:name])
		item.save
	end

	def create_service
		service = Service.new(name: params[:service][:name])
		service.save
	end
end
