class Indication < ActiveRecord::Base
  attr_accessible :name, :oldid

  default_scope order(:name)

  def to_s
    name
  end

  def name_and_id
    {'id' => id, 'text' => name}
  end
end
