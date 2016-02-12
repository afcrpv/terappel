require 'spec_helper'

describe Malformation do
  subject { create(:malformation) }

  describe '#libelle_and_id' do
    it 'should return a hash with id and libelle values' do
      subject.libelle_and_id.should == { 'id' => subject.id, 'text' => subject.libelle }
    end
  end
end
