require 'spec_helper'

describe "routes for Dossiers" do
  it "/:centre_id/new to Dossiers#new" do
    path = new_centre_dossier_path 'foocentre'
    path.should == '/foocentre/new'
    { :get => path }.should route_to(
      :controller => 'dossiers',
      :action => 'new',
      :centre_id => 'foocentre'
    )
  end

  it "/:centre_id/:code to Dossiers#show" do
    { :get => "/foocentre/LY-2011-01" }.should route_to(
      :controller => 'dossiers',
      :action => 'show',
      :centre_id => 'foocentre',
      :id => "LY-2011-01"
    )
  end

  it "/:centre_id/:code/edit to Dossiers#edit" do
    { :get => "/foocentre/LY-2011-01/edit" }.should route_to(
      :controller => 'dossiers',
      :action => 'edit',
      :centre_id => 'foocentre',
      :id => "LY-2011-01"
    )
  end
end
