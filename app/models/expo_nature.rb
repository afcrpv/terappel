class ExpoNature < ActiveRecord::Base
  default_scope { order(:name) }
end
