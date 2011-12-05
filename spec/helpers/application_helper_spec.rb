#encoding: utf-8
require 'spec_helper'
include Devise::TestHelpers

describe ApplicationHelper do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = Factory(:admin)
    sign_in user
  end

  let(:dossier) {Factory(:dossier, :code => "1101001")}

  describe "#actions" do
    let(:html) {helper.actions {"<li>action1</li><li>action2</li>".html_safe}}

    it "should create a wrapping nav.action_links" do
      html.should match(/nav class="action_links"/)
    end
    it "should wrap the provided block in ul" do
      html.should match(/<ul><li>action1/)
    end
  end

  describe "#action_button" do
    context "with a 'destroy' action" do
      let(:html) {helper.action_button(dossier, "destroy")}

      it "should render a link to destroy the provided object " do
        html.should =~ /a href="\/dossiers\/1101001" class="destroy_button" data-confirm="Etes-vous sûr \?" data-method="delete" rel="nofollow"><img alt="Détruire"/
      end
    end
    context "with a 'show' action" do
      let(:html) {helper.action_button(dossier, "show")}

      it "should render a link to show the provided object " do
        html.should match(/a href="\/dossiers\/1101001" class="show_button" data-method="get"><img alt="Détails"/)
      end
    end
    context "with a 'edit' action" do
      let(:html) {helper.action_button(dossier, "edit")}

      it "should render a link to edit the provided object " do
        html.should match(/a href="\/dossiers\/1101001\/edit" class="edit_button" data-method="get"><img alt="Modifier"/)
      end
    end
  end
end
