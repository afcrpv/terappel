require 'spec_helper'

describe "routes for Centres" do
  it "/to Centres#index" do
    path = centres_path
    path.should == "/"
    { :get => path }.should route_to(
      :controller => "centres",
      :action => 'index'
    )
  end
end
