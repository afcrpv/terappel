require 'spec_helper'
require "cancan/matchers"

describe User do
  it "requires a unique email" do
    existing_user = create(:user)
    User.new.should have(2).error_on(:email)
    User.new(email: existing_user.email).should have(2).error_on(:email)
  end

  it "requires a unique username" do
    existing_user = create(:user)
    User.new.should have(1).error_on(:username)
    User.new(username: existing_user.username).should have(1).error_on(:username)
  end

  it "requires a belonging crpv" do
    User.new.should have(1).error_on(:centre_id)
  end

  it "should not be approved on creation" do
    build_stubbed(:user).should_not be_approved
  end

  it "should approve user unless unapproved" do
    user = create(:user)
    user.approve!
    user.should be_approved
  end

  describe "abilities" do
    subject { ability }
    let(:ability) { Ability.new(user) }
    let(:user_from_same_center) {create(:member, centre: user.centre)}
    let(:user_from_other_center) {create(:member)}
    let(:dossier) {build(:dossier, centre: user.centre)}
    let(:dossier_from_other_center) {create(:dossier, centre: user_from_other_center.centre)}

    context "for a member" do
      let(:user) {create(:member)}
      let(:correspondant) {create(:correspondant, centre: user.centre)}
      let(:correspondant_from_other_center) {create(:correspondant, centre: user_from_other_center.centre)}

      it { should be_able_to :index, :home }
      it { should be_able_to :update, user }

      it { should be_able_to :create, :dossiers }
      it { should be_able_to :index, :dossiers }
      it { should be_able_to :show, dossier }
      it { should_not be_able_to :show, dossier_from_other_center }
      it { should be_able_to :update, dossier }
      it { should_not be_able_to :destroy, dossier }

      it { should be_able_to :create, :correspondants }
      it { should be_able_to :show, correspondant }
      it { should be_able_to :index, correspondant }
      it { should be_able_to :update, correspondant }
      it { should_not be_able_to :show, correspondant_from_other_center }
      it { should_not be_able_to :index, correspondant_from_other_center }
      it { should_not be_able_to :update, correspondant_from_other_center }
      it { should_not be_able_to :destroy, :correspondants }

      [:produits, :malformations, :pathologies, :searches].each do |model|
        it { should be_able_to :read, model}
      end
      it { should be_able_to :create, :searches}
      it { should be_able_to :update, :searches}
      it { should_not be_able_to :index, :searches}
      it { should_not be_able_to :destroy, :searches}
    end

    context "for an admin:" do
      let(:user) {create(:admin)}

      it {should be_able_to(:access, :all)}
      it {should_not be_able_to :destroy, user}
    end
  end
end
