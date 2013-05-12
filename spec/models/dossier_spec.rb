require 'spec_helper'

describe Dossier do
  let(:centre) {create(:centre, name: "lyon", code: "ly")}
  let(:dossier) {create(:dossier)}

  subject {dossier}

  describe "#correspondant_nom" do
    it "should return correspondant_fullname" do
      subject.correspondant = create(:correspondant)
      subject.save!
      subject.correspondant_nom.should == subject.correspondant_fullname
    end
  end
end
