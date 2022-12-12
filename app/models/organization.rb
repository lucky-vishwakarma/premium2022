class Organization < ApplicationRecord
	has_many :billings
	validates :name, presence: true
	validates :address, presence: true
end
