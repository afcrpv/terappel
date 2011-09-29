require 'spec_helper'

describe LayoutHelper do
  describe "#default_title" do
    before do
      I18n.locale = "fr"
    end
    context "with no parameteres passed" do
      it "concats controller action with singularized controller name" do
        helper.stub!(:action_name).and_return('new')
        helper.stub!(:controller_name).and_return('dossiers')
        helper.default_title.should == "Nouveau Dossier"
      end
    end
    context "when interpolations parameters are present" do
      it "should pass them to the translator" do
        helper.stub!(:action_name).and_return('show')
        helper.stub!(:controller_name).and_return('dossiers')
        helper.default_title(:id => "1").should == "Dossier #1"
      end
    end
  end
end
