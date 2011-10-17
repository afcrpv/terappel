require 'spec_helper'

describe Dossier do
  let(:centre) {Factory(:centre, :name => "lyon", :code => "ly")}
  let(:dossier) {Factory(:dossier, :centre => centre, :date_appel => "31/01/2011")}

  subject {dossier}

  its(:to_param) {should == dossier.code}

  it {should be_valid}

  it "should require a name" do
    subject.name = ""
    subject.should_not be_valid
  end

  it "should require a date_appel" do
    subject.date_appel = ""
    subject.should_not be_valid
  end

  it "should require an associated centre" do
    subject.centre_id = nil
    subject.should_not be_valid
  end

  it "should require an associated user" do
    subject.user_id = nil
    subject.should_not be_valid
  end


  describe "#centre_name" do
    it "should return the name of the associated centre" do
      subject.centre_name.should == "lyon"
    end
  end

  describe "#centre_code" do
    it "should return the code of the associated centre" do
      subject.centre_code.should == "ly"
    end
  end

  its(:year) {should == Time.now.to_date.year.to_s}

  describe "after save" do
    context "when creating a new dossier" do
      it "should assign code" do
        dossier.code.should == "LY-2011-1"
      end
    end
    context "when updating an existing dossier" do
      it "should reprocess code" do
        dossier.update_attribute(:date_appel, "1/1/2001")
        dossier.code.should == "LY-2001-1"
      end
    end
  end
end
