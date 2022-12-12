class Cart < ApplicationRecord
	belongs_to :billing
	belongs_to :item
	belongs_to :service
	default_scope {order('id DESC')}
end