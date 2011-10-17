class ActiveRecord::Base
  attr_accessible
  attr_accessor :accessible

  private

  def mass_assignment_authorizer(role = :default)
    if accessible == :all
      #this is a hack to return all the attributes since we're not using protected
      self.class.protected_attributes(role = role)
    else
      super(role) + (accessible || [])
    end
  end
end
