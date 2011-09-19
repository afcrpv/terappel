require "spec_helper"

describe "routes for Sessions" do
  it "routes /login to the /sessions/new action" do
    { :get => "/login" }.
      should route_to(:controller => "sessions", :action => "new")
  end
  it "routes /logout to the /sessions/destroy" do
    { :get => "/logout" }.
      should route_to(:controller => "sessions", :action => "destroy")
  end
end
