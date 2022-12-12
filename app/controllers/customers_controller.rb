class CustomersController < ApplicationController
  # before_action :check_admin_user
  skip_before_action :verify_authenticity_token, only: [:download]
  before_action :get_organizations, only: [:index]
  before_action :find_customer, only: [:reminder_sms, :send_reminder_sms, :show, :destroy]

  def index
    @q = Customer.ransack(params[:q])
    @customers = @q.result.order('id DESC').paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|
      format.html
      format.csv {send_data @customers.to_csv, disposition: :inline}
    end
  end

  def show
    @balances = @customer.balances.paginate(:page => params[:page], :per_page => 10)
  end

  def reminder_sms
  end

  def send_reminder_sms
    res = @customer.send_sms(params[:message])
    if res["status"] == "success"
      flash[:success] = "Message sent successfully"
    else
      flash[:danger] = res["message"]
    end
    redirect_to billings_path(page: params[:page])
  end

  def send_bulk_sms
    params[:customer_numbers].each do |number|
      Sms.send_sms(params[:sms], number)
    end
    flash[:success] = "Message sent successfully"
    redirect_to customers_path
  end

  def download
    # binding.pry
    @customers = Customer.all#.where(id: params[:ids])
      respond_to do |format|
        format.csv {send_data @customers.to_csv, filename: "#{Date.today}.csv", disposition: :attachment}
      end
  end

  def destroy
    @balance = @customer.balances.find_by(id: params[:balance_id])
    @balance.delete
    redirect_to customer_path(@customer)
  end
  
  private

    def find_customer
      @customer = Customer.find_by(id: params[:id])
    end

    def cusomer_params
        params.require(:customer).permit(:name, :phone, :address)
    end
end
