class Formule < ActiveRecord::Base
  default_scope {order(:name)}
end
