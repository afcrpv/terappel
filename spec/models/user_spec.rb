require 'spec_helper'

describe User do
  valid_attrs = {:username => "user",
                 :email => "user@test.com",
                 :password => "secret",
                 :password_confirmation => "secret"}
  let(:valid_user) {User.create(valid_attrs)}

  it {should_not be_valid}
  it "should be valid with username, email and password" do
    subject.username = "value for username"
    subject.email = "value for email"
    subject.password = "secret"
    subject.password_confirmation = "secret"
    subject.should be_valid
  end

  it "should require a unique username" do
    User.new(valid_attrs)
    subject.email = "value for email"
    subject.should_not be_valid
  end

  it "should require a unique email" do
    User.new(valid_attrs)
    subject.username = "value for username"
    subject.should_not be_valid
  end
end
