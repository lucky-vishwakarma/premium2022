class CsvsController < ApplicationController

	def index
		years = [2019, 2020, 2021,  2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030]
		months = [1,2,3,4,5,6,7,8,9,10,11,12]
		@records ={}
		years.each do |year|
			@records[year] = []
			months.each do | month|
				@billings = Billing.where('extract(year from booking_date)=?', year).where('extract(month from booking_date)=?', month)
				@records[year] << ["#{month}"=> @billings] if @billings.present?	
			end
		end
	end

	def download
		billings = Billing.where('extract(year from booking_date)=?', params[:year]).where('extract(month from booking_date)=?', params[:month])
		@delivered_billings = billings.delivered
		respond_to do |format|
	      format.html
	      format.csv {send_data @delivered_billings.to_csv, disposition: :inline, filename: "#{params[:year]}-#{params[:month]}.csv"}
	    end
	end

	def destroy
		billings = Billing.where('extract(year from booking_date)=?', params[:year]).where('extract(month from booking_date)=?', params[:month])
		@delivered_billings = billings.delivered
		@delivered_billings.destroy_all
		redirect_to csvs_path
	
	end
end