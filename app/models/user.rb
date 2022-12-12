class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    validates :name, :presence => true, uniqueness: { case_sensitive: false }

  #scope
  scope :staff, -> {where("role = ?", "Staff")}
  scope :admin, -> {where("role = ?", "Admin")}
  scope :vendor, -> {where("role = ?", "Vendor")}
  scope :active, -> {where("active = ?", true)}
  default_scope {order('id DESC')}

  def admin?
  	role == "Admin"
  end

  def staff?
  	role == "Staff"
  end

   def client?
  	role == "Vendor"
  end

  def get_status
    self.active ? "Active" : "In-Active"
  end

  def get_active_lable
    self.active ? "In-Active" : "Active"
  end

  def status_update 
    self.active ? self.update_attributes(active: false) : self.update_attributes(active: true)
  end
end