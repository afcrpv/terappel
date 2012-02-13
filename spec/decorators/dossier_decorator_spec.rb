#encoding: utf-8
require 'spec_helper'

describe DossierDecorator do
  include ActionView::Helpers::TextHelper
  before { ApplicationController.new.set_current_view_context }

  let(:dossier) { Factory(:dossier) }
  let(:decorated_dossier) { DossierDecorator.decorate(dossier)}

  describe "#atcds_grs" do
    subject {decorated_dossier.atcds_grs}
    context "when 0" do
      before { dossier.grsant = 0}
      it { should == "primipare-primigeste"}
    end
    context "when > 0" do
      context "for nai = 1" do
        before do
          dossier.grsant = 1
          dossier.nai = 1
        end
        it { should == "1 (1 naissance)"}
      end
      context "for nai = 2, ivg = 2, fcs = 2" do
        before do
          dossier.grsant = 6
          dossier.nai = 2
          dossier.ivg = 2
          dossier.fcs = 2
        end
        it { should == "6 (2 FCS, 2 IVG et 2 naissances)"}
      end
    end
  end
  describe "#button_to_modal" do
    it "should render a link to open a modal with dossier details" do
      html = "<a href=\"#dossier_1_modal\" class=\"btn btn-small\" data-toggle=\"modal\"><i class='icon-info-sign'></i>\nDétails</a>"
      decorated_dossier.button_to_modal.should == html
    end
  end

  describe "#handle_none" do
    context "when value is present" do
      it "should yield the value" do
        decorated_dossier.send(:handle_none, "bla") { "bla "} == "bla"
      end
    end
    context "when value is not present" do
      context "when message is not given as argument" do
        it "should return the default message" do
          decorated_dossier.send(:handle_none, nil).should =~ /Non spécifié\(e\)/
        end
      end
      context "when message is provided" do
        it "should use it" do
          decorated_dossier.send(:handle_none, nil, "Aucun").should =~ /Aucun/
        end
      end
    end
  end

  describe "#patiente" do
    it "should render the patient's name+prenom" do
      dossier.name = "Martin"
      dossier.prenom = "Martine"
      decorated_dossier.patiente.should == "MARTIN Martine"
    end
  end

  %w(fam perso).each do |atcds|
    describe "#atcds_#{atcds}" do
      context "when = 'Non'" do
        it "should return 'Aucun'" do
          dossier.send("antecedents_#{atcds}=", "1")
          decorated_dossier.send("atcds_#{atcds}").should == "Aucun"
        end
      end
      context "when = 'Oui'" do
        before(:each) { dossier.send("antecedents_#{atcds}=", "0")}
        context "when the related commentary is filled" do
          it "should return the #comm_antecedents_#{atcds} value" do
            dossier.send("comm_antecedents_#{atcds}=", "Bla, and bla bla")
            decorated_dossier.send("atcds_#{atcds}").should == "Bla, and bla bla"
          end
        end
        context "when the related commentary is empty" do
          it "should return 'Non spécifié(e)'" do
            decorated_dossier.send("atcds_#{atcds}").should =~ /Non spécifié/
          end
        end
      end
    end
  end
end
