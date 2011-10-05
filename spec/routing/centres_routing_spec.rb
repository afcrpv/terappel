require 'spec_helper'

describe "routes for Centres" do
  it "/ to Centres#index" do
    path = centres_path
    path.should == "/centres"
    { :get => path }.should route_to(
      :controller => "centres",
      :action => 'index'
    )
  end

  it "/:id to Centres#show" do
    path = centre_path 'foocentre'
    path.should == "/foocentre"
    { :get => path }.should route_to(
      :controller => "centres",
      :action => 'show',
      :id => 'foocentre'
    )
  end
end
