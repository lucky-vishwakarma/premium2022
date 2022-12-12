class Customer < ApplicationRecord
  has_many :billings
  has_many :balances
  validates :phone, uniqueness: true, allow_nil: true
  #scope
  scope :uniq_phone, -> {where("phone IS NOT ?", nil).pluck(:phone)}
  default_scope {order('id DESC')}

  def self.with_organization organization_id
  	Customer.joins(:billings).where('billings.organization_id = ?',organization_id.to_i)
  end

  def send_sms message
  	Sms.send_sms(message, phone)
  end

  def balance_amount
    if self.balances.present?
      self.balances.last.status == "pending" ? self.balances.last : nil
    end 
  end

  def self.to_csv(options = {})
    # attributes = %w{id name}
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |customer|
        csv << customer.attributes.values
      end
    end
  end

  def customer_balance_amount 
    if self.balances.present?
      advance_amount = self.balances.pending.sum(:advance_amount)
      due_amount = self.balances.pending.sum(:due_amount)
      [advance_amount, due_amount]
    else
      [0,0]
    end
  end
end