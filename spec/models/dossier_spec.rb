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

  describe "#correspondant_nom" do
    it "should return correspondant_fullname" do
      correspondant = Factory(:correspondant)
      subject.correspondant = correspondant
      subject.save!
      subject.correspondant_nom.should == subject.correspondant_fullname
    end
  end
end
