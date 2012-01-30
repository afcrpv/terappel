require 'spec_helper'

describe Correspondant do
  subject {Factory.build(:correspondant)}
  describe "after create" do
    it "should assign fullname" do
      subject.nom = "Nom"
      subject.cp = "69"
      subject.ville = "Lyon"
      subject.save!
      subject.fullname.should == "Nom - 69 - Lyon"
    end
  end
  describe "before update" do
    it "should assign fullname" do
      subject.save!
      subject.nom = "Nom"
      subject.cp = "69"
      subject.ville = "Lyon"
      subject.save!
      subject.fullname.should == "Nom - 69 - Lyon"
    end
  end
end
