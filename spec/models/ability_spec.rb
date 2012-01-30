require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:centre) {Factory(:centre)}
  let(:other_centre) {Factory(:centre)}
  let(:user) {Factory(:user, :centre => centre)}
  let(:user_from_other_center) {Factory(:user, :centre => other_centre)}
  let(:user_from_same_center) {Factory(:user, :centre => centre)}
  let(:dossier) {Factory(:dossier, :centre => centre, :user => user)}
  let(:dossier_from_same_center) {Factory(:dossier, :centre => centre, :user => user_from_same_center)}
  let(:dossier_from_other_center) {Factory(:dossier, :centre => other_centre)}

  context "for a centre user" do
    before do
      user.role = "centre_user"
    end

    subject { Ability.new(user) }

    it { should be_able_to :access, :rails_admin}
    it { should be_able_to :read, centre}
    it { should be_able_to :read, user }
    it { should be_able_to :read, UserDecorator }
    it { should be_able_to :update, user }
    it { should_not be_able_to :destroy, user }

    it { should be_able_to :read, DossierDecorator }
    it { should be_able_to :manage, dossier_from_same_center }
    it { should_not be_able_to :destroy, dossier }
    it { should_not be_able_to :destroy, dossier_from_same_center }
    it { should_not be_able_to :destroy, dossier_from_other_center }

    [Produit, Malformation, Pathologie].each do |model|
      it { should be_able_to :read, model}
    end
    [Bebe, Exposition].each do |model|
      it { should be_able_to :manage, model}
    end
  end

  context "for a centre admin" do
    before do
      user.role = "centre_admin"
    end

    subject { Ability.new(user) }

    it {should be_able_to :destroy, dossier_from_same_center}
    it {should_not be_able_to :update, dossier_from_other_center}
    it {should_not be_able_to :destroy, dossier_from_other_center}

    it {should be_able_to :update, centre}

    it {should be_able_to :manage, user_from_same_center}
    it {should_not be_able_to :destroy, user}
    it {should_not be_able_to :manage, user_from_other_center}
  end

  context "for an admin:" do
    let(:user) {Factory(:admin, :centre => centre)}

    subject { Ability.new(user) }

    it {should be_able_to :manage, :all}
    it {should_not be_able_to :destroy, user}
  end
end
