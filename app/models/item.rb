class Item < ApplicationRecord
	has_many :carts
	default_scope {order('id DESC')}
end
