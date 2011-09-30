require 'spec_helper'
require "cancan/matchers"

describe Ability do
  context "for an admin:" do
    admin = Factory.build(:admin)
    subject { Ability.new(admin) }
    it { should be_able_to(:manage, :all) }
  end
  context "for a centre_admin" do
    centre = Centre.new
    user = centre.users.build
    user.role = "centre_admin"
    subject { Ability.new(user) }
    it { should be_able_to(:update, centre.dossiers.build) }
  end
  context "for a simple auth user" do
    centre = Centre.new
    user = centre.users.build
    dossier = user.dossiers.build
    subject { Ability.new(user) }
    it { should be_able_to(:read, Dossier)}
    it { should be_able_to(:create, Dossier)}
    it { should be_able_to(:update, dossier)}
  end
end
