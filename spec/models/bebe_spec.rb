require 'spec_helper'

describe Bebe do
  let(:bebe) {create(:bebe)}
  subject {bebe}

  %w(malformation pathologie).each do |association|
    before do
      (1..2).each do |n|
        create(association, libelle: association + n.to_s)
      end
    end
    describe "##{association}_tokens=" do
      it "should split the provided string of ids and assign them to #{association}_ids" do
        subject.send("#{association}_tokens=", "1,2")
        subject.send("#{association}_ids").should == [1,2]
      end
    end
    describe "##{association}_names" do
      it "should return a sentence of #{association} names" do
        subject.send("#{association}s=", association.classify.constantize.all)
        subject.send("#{association}_names").should == "#{association}1 et #{association}2"
      end
    end
  end
end
