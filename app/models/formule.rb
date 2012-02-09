class Formule < ActiveRecord::Base
  attr_accessible :name, :oldid
  default_scope order(:name)
end
