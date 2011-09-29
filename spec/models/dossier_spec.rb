require 'spec_helper'

describe Dossier do
  it {should_not be_valid}

  it "should be valid with name and date_appel" do
    dossier = Factory(:dossier)
    dossier.should be_valid
  end
end
