require 'spec_helper'

describe User do
  let(:existing_user) {Factory(:user)}
  subject {Factory.build(:user)}

  it {should be_valid}

  it "should require username" do
    subject.username = ""
    subject.should_not be_valid
  end

  it "should require a unique username" do
    subject.username = existing_user.username
    subject.should_not be_valid
  end

  it "should require a confirmation of password" do
    subject.password_confirmation = ""
    subject.should_not be_valid
  end

  it "should require email" do
    subject.email = ""
    subject.should_not be_valid
  end

  it "should require a unique email" do
    subject.email = existing_user.email
    subject.should_not be_valid
  end

  it "should inherit lower roles" do
    subject.role = "admin"
    admin = subject
    admin.role?(:centre_admin).should be_true
    admin.role?(:centre_user).should be_true
    subject.role = "centre_user"
    centre_user = subject
    centre_user.role?(:centre_admin).should_not be_true
    centre_user.role?(:admin).should_not be_true
  end

  describe "#centre_name" do
    it "should return name of associated centre" do
      centre = Factory(:centre, :name => "lyon")
      subject.centre_id = centre.id
      subject.centre_name.should == "lyon"
    end
  end
end
