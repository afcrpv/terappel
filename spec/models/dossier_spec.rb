require 'spec_helper'

describe Dossier do
  it {should_not be_valid}

  it "should be valid with name and date_appel" do
    subject.name = "Martin"
    subject.date_appel = Time.now.to_date
    subject.should be_valid
  end

  describe "#code" do
    it "should concat centre_code + date_appel.year + dossier index by year" do
      centre = Factory(:centre, :code => "ly")
      dossier = centre.dossiers.create(
        :name => "dupont",
        :date_appel => "31/1/2011")
      dossier.year.should == "2011"
      dossier.dossiers_years.should == {"2011" => [dossier]}
      dossier.code.should == "LY-2011-1"
    end
  end
end
