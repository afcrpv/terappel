require 'rails_helper'

describe Correspondant do
  subject { build(:correspondant) }
  let(:specialite) { create(:specialite, name: "généraliste") }
  describe 'after create' do
    it 'should assign fullname' do
      subject.nom = 'Nom'
      subject.cp = '69'
      subject.ville = 'Lyon'
      subject.specialite = specialite
      subject.save!
      subject.fullname.should == "Nom - généraliste - 69 - Lyon"
    end
  end
  describe 'before update' do
    it 'should assign fullname' do
      subject.save!
      subject.nom = 'Nom'
      subject.cp = '69'
      subject.ville = 'Lyon'
      subject.specialite = specialite
      subject.save!
      subject.fullname.should == "Nom - généraliste - 69 - Lyon"
    end
  end
end
