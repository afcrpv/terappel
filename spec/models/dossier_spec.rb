require 'spec_helper'

describe Dossier do
  before do
    Dossier.destroy_all
    Centre.destroy_all
  end
  after do
    Dossier.destroy_all
    Centre.destroy_all
  end
  subject {Dossier.new(:name => "Martin", :date_appel => Time.now.to_date)}

  it {should be_valid}

  its(:year) {should == Time.now.to_date.year.to_s}

  
  let(:centre) {Factory(:centre, :code => "ly")}
  let(:dossier) do
    centre.dossiers.create(
      :name => "dupont",
      :date_appel => "31/1/2011")
  end

  describe "after creation" do
    it "should assign code" do
      dossier.code.should == "LY-2011-1"
    end
  end
end
