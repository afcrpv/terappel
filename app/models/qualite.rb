class Qualite < ActiveRecord::Base
  default_scope {order(:name)}
end
