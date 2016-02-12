require 'spec_helper'

describe ApplicationHelper do
  describe '#errors_for' do
    let(:dossier) { Dossier.new }
    before(:each) { dossier.save }
    context 'with no message parameter provided' do
      it 'returns a default title' do
        html = %(<div class="alert alert-danger alert-block dossier-errors"><button class="close" data-dismiss="alert" type="button">&times;</button><h4>Des erreurs ont été trouvées, vérifiez :</h4><ul><li>le champ <a data-field="dossier_name" href="#">Nom patiente</a> doit être rempli</li><li>le champ <a data-field="dossier_date_appel" href="#">Date d'appel</a> doit être rempli</li><li>le champ <a data-field="dossier_centre_id" href="#">Centre</a> doit être rempli</li><li>le champ <a data-field="dossier_expo_terato" href="#">Témoin</a> doit être rempli</li><li>le champ <a data-field="dossier_a_relancer" href="#">Relance</a> doit être rempli</li><li>le champ <a data-field="dossier_code" href="#">N° d'appel</a> doit être rempli</li><li>vous devez saisir au moins 1 produit dans l'onglet <a data-field="dossier_expositions" href="#">Exposition</a></li></ul></div>)
        helper.errors_for(dossier).should == html
      end
    end
    context 'with a custom title as a 2nd param' do
      it 'ads the custom title' do
        helper.errors_for(dossier, 'Saperlipoetto !').should match /<h4>Saperlipoetto !<\/h4>/
      end
    end
  end
end
