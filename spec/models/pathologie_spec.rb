require 'spec_helper'

describe Pathologie do
  subject {Factory(:pathologie)}

  describe "#libelle_and_id" do
    it "should return a hash with id and libelle values" do
      subject.libelle_and_id.should == {"id" => subject.id, "libelle" => subject.libelle}
    end
  end
end
