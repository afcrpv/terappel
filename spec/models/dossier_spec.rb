require 'spec_helper'

describe Dossier do
  it {should_not be_valid}

  it "should be valid with name and date_appel" do
    subject.name = "Martin"
    subject.date_appel = Time.now.to_date
    subject.should be_valid
  end
end
