require 'spec_helper'

describe SessionsController do
  before do
    @user = Factory(:user)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      login_user
      get :destroy
      response.should redirect_to(root_url)
    end
  end
end
