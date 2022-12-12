Rails.application.routes.draw do
  devise_for :users
  root :to=>"dashboards#welcome"

  resources :dashboards
  get "welcome", to: "dashboards#welcome"
  get "base", to: 'dashboards#index'

  resources :attendances, only: [:index, :create, :update] do
    get :payments, on: :collection
    get :payment_done, on: :collection
    post :delete_record, on: :collection
  end
  
  resources :billings, only: [:new, :create, :edit, :show, :update, :index, :destroy] do 
    put :update_status, on: :member
    get :cancel, on: :member
    post :delevery_done, on: :member
    put :delevery, on: :member
    get :get_bill_no, on: :collection
    patch :update_final_billing, on: :member
  	resources :carts, only: [:create, :new, :destroy]

  end 
  resources :customers, only: [:index, :show, :new, :create, :destroy] do 
    post :send_reminder_sms, on: :member
    get :reminder_sms, on: :member
    post :send_bulk_sms, on: :collection
    get :download, on: :collection
  end

  resources :employees, only: [:index, :create, :update, :destroy]

  resources :accounts, only: [:index, :create, :update] do
    post :delete_record, on: :collection
  end
  resources :vendor_billings do 
    get :get_monthaly_record, on: :collection
    get :payment_done, on: :collection
    get :change_amount, on: :member
    post :update_amount, on: :member
    post :delete_record, on: :collection
  end
  resources :extra, only: [:index] do
    post :create_item, on: :collection
    post :create_service, on: :collection
    get :billing, on: :collection
  end

  resources :csvs, only: [:index] do 
    get :get_monthly_record, on: :collection
    get "/download/:year/:month",  to: "csvs#download", on: :collection
    get "/destroy/:year/:month",  to: "csvs#destroy", on: :collection
  end
end
