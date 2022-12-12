class Service < ApplicationRecord
	default_scope {order('id DESC')}
end
