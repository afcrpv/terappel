require 'spec_helper'

describe "routes for Dossiers" do
  it "/:centre_id/ to Dossiers#index" do
    path = centre_dossiers_path 'foocentre'
    path.should == "/foocentre/dossiers"
    { :get => path }.should route_to(
      :controller => 'dossiers',
      :action => 'index',
      :centre_id => 'foocentre'
    )
  end

  it "/:centre_id/new to Dossiers#new" do
    path = new_centre_dossier_path 'foocentre'
    path.should == '/foocentre/new'
    { :get => path }.should route_to(
      :controller => 'dossiers',
      :action => 'new',
      :centre_id => 'foocentre'
    )
  end

  it "/:centre_id/:dossier_id to Dossiers#show" do
    path = centre_dossier_path 'foocentre', 'code_dossier'
    path.should == '/foocentre/code_dossier'
    { :get => path }.should route_to(
      :controller => 'dossiers',
      :action => 'show',
      :centre_id => 'foocentre',
      :id => 'code_dossier'
    )
  end

  it "/:centre_id/:dossier_id/edit to Dossiers#edit" do
    path = edit_centre_dossier_path 'foocentre', 'code_dossier'
    path.should == '/foocentre/code_dossier/edit'
    { :get => path }.should route_to(
      :controller => 'dossiers',
      :action => 'edit',
      :centre_id => 'foocentre',
      :id => 'code_dossier'
    )
  end
end
