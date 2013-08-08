class Indication < ActiveRecord::Base
  default_scope {order(:name)}

  def self.search_by_name(string)
    where("LOWER(name) like ?", "%#{string}%")
  end

  def to_s
    name
  end

  def name_and_id
    {'id' => id, 'text' => name}
  end
end
