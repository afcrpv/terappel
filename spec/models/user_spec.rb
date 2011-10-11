require 'spec_helper'

describe User do
  before do
    User.destroy_all
  end

  after do
    User.destroy_all
  end

  let(:existing_user) {Factory(:user)}
  subject {User.new}

  it {should_not be_valid}

  it "should be valid with username, email and password" do
    subject.username = "value for username"
    subject.email = "test@test.com"
    subject.password = "secret"
    subject.password_confirmation = "secret"
    subject.should be_valid
  end

  it "should require a unique username" do
    subject.username = existing_user.username
    subject.should_not be_valid
  end

  it "should require a unique email" do
    subject.email = existing_user.email
    subject.should_not be_valid
  end

  context "when using admin role" do
    it "should allow centre_id to be mass assigned" do
      subject = User.new({:centre_id => 1}, :as => :admin)
      subject.attributes.should include("centre_id" => 1)
    end
    it "should allow role to be mass assigned" do
      subject = User.new({:role => "role"}, :as => :admin)
      subject.attributes.should include("role" => "role")
    end
  end
end
