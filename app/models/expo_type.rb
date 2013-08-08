class ExpoType < ActiveRecord::Base
  default_scope {order(:name)}
end
