require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:user) {build_stubbed(:user)}
  let(:user_from_other_center) {create(:user)}
  let(:user_from_same_center) {create(:user, centre: user.centre)}
  let(:dossier) {create(:dossier, centre: user.centre)}
  let(:dossier_from_same_center) {create(:dossier, centre: user.centre)}
  let(:dossier_from_other_center) {create(:dossier, centre: user_from_other_center.centre)}
  let(:correspondant_from_same_center) {create(:correspondant, centre: user.centre)}

  subject { ability }
  let(:ability) { Ability.new(user) }
  context "for a centre user" do

    let(:user) {build(:centre_user)}

    it { should be_able_to :read, user }
    it { should be_able_to :update, user }
    it { should_not be_able_to :destroy, User }

    it { should be_able_to :manage, dossier_from_same_center }
    it { should_not be_able_to :destroy, Dossier }

    it { should be_able_to :create, Correspondant }
    it { should be_able_to :read, correspondant_from_same_center }
    it { should be_able_to :update, correspondant_from_same_center }
    it { should_not be_able_to :destroy, Correspondant }

    [Produit, Malformation, Pathologie, Search].each do |model|
      it { should be_able_to :read, model}
    end
    [Bebe, Exposition, Search].each do |model|
      it { should be_able_to :manage, model}
    end
    it { should_not be_able_to :index, Search}
    it { should_not be_able_to :destroy, Search}
  end

  context "for a centre admin" do
    let(:user) { build(:centre_admin) }

    it {should be_able_to :read, user.centre}
    it {should be_able_to :destroy, dossier_from_same_center}
    it {should_not be_able_to :update, dossier_from_other_center}
    it {should_not be_able_to :destroy, dossier_from_other_center}

    it {should be_able_to :update, user.centre}

    it {should be_able_to :manage, user_from_same_center}
    it {should_not be_able_to :destroy, user}
    it {should_not be_able_to :manage, user_from_other_center}
  end

  context "for an admin:" do
    let(:user) {build(:admin)}

    it {should be_able_to :manage, :all}
    it {should_not be_able_to :destroy, user}
  end
end
