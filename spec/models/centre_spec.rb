require 'spec_helper'

describe Centre do
  it { should_not be_valid}

  let(:centre) { create(:centre) }
  it "should require a unique name" do
    subject.name = "Centre"
    subject.should be_valid
  end
end
