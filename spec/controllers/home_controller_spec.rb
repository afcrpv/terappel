require 'spec_helper'

describe HomeController do

  before do
    @user = Factory(:user)
    login_user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
