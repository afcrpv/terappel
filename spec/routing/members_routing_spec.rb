require "spec_helper"

describe "routes for Members" do
  it "/:centre_id/members/new to Users#new" do
    path = new_centre_user_path 'foocentre'
    path.should == "/foocentre/members/new"

    { :get => path }.should route_to(
      :controller => 'users',
      :action => 'new',
      :centre_id => 'foocentre'
    )
  end
end
