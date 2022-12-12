class BillingsController < ApplicationController
  before_action :find_billing, only: [:show, :update, :update_status, :cancel, :delevery, :delevery_done, :update_final_billing, :edit, :destroy]
  before_action :get_organizations, only: [:index, :show, :new, :create, :edit]

  def index
    @q = Billing.includes(:customer, :carts).ransack(params[:q])
    billings = @q.result
    if params[:q]
      @billings = billings.uniq
    else
      @billings = billings.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def new
    if Billing.first.present?
      @billing = Billing.new(bill_no: Billing.first.bill_no+1)
    else
      @billing = Billing.new(bill_no: 23201)
    end
  end

  def show
  end

  def edit
    if @billing.delivered?
      redirect_to billing_path(@billing)
    else
      render 'new'
    end
  end

  def create
    @billing = Billing.new(billing_params)
    unless verify_phone_number(params[:phone])
      flash[:danger] = "Invalid contact number."
      render 'new' and return 
    end
      @billing.create_customer(params[:phone], params[:name])
    if @billing.save
      flash[:success] = "Successfully created."
      redirect_to billing_path(@billing)
    else
      flash[:danger] = @billing.errors.full_messages.join(',')
      render 'new'
    end
  end


  def update
    @billing.update_attributes(billing_params)
    @billing.update_customer_info(params[:phone], params[:name]) if params[:phone].present? || params[:name].present?
    @billing.update_all_parameter
    redirect_to billing_path(@billing)
  end

  def update_final_billing
    @billing.update_final_billing_with_advance_amount(params[:billing])    
    # @billing.send_order_confirm_sms
    redirect_to billing_path(@billing)
  end

  def update_status
    status = params[:status]=="reorder" ? "pending" : params[:status]
    @billing.update_attributes(status: status)
    # @billing.send_order_complete_sms if @billing.complete?
    redirect_to billings_path(page: params[:page])
  end

  def cancel
    @billing.update_attributes(status: "canceled")
    redirect_to billings_path
  end

  def delevery
  end

  def delevery_done
    @billing.update_billing(params[:total_paid_amount])  
    redirect_to billings_path(page: params[:page])
  end

  def get_bill_no
    org = Organization.find_by(id: params[:shop_id])
    bill_no = org.billings.first.bill_no + 1
    render json: {bill_no: bill_no}, status: 200
  end

  def destroy
     if @billing.delete
      flash[:success] = "Successfully Deleted"
     else
      flash[:danger] = "Something went wrong."
     end
     redirect_to billings_path
  end
  
  private

  def find_billing
    @billing = Billing.find_by(id: params[:id])
  end

  def billing_params
    params.require(:billing).permit(:booking_date, :bill_no, :due_date,:organization_id, carts_attributes: [:id, :quantity, :item_id, :amount, :service_id, :remark, :_destroy])
  end

  def verify_phone_number phone_number
    phone_number.length == 10 ? true : false
  end

end
