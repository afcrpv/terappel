require 'spec_helper'

describe Pathologie do
  subject {create(:pathologie)}

  describe "#libelle_and_id" do
    it "should return a hash with id and libelle values" do
      subject.libelle_and_id.should == {"id" => subject.id, "text" => subject.libelle}
    end
  end
end
