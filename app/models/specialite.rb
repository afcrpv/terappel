class Specialite < ActiveRecord::Base
  default_scope { order(:name) }
end
