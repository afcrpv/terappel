require 'rails_helper'

describe Pathology do
  subject { create(:pathology) }

  describe '#libelle_and_id' do
    it 'should return a hash with id and libelle values' do
      expect(subject.libelle_and_id).to eq(id: subject.id, text: subject.libelle)
    end
  end
end
