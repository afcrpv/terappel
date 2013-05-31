require "spec_helper"

describe ApplicationHelper do
  describe "#errors_for" do
    let(:dossier) { Dossier.new }
    context "with no message parameter provided" do
      it "returns a default title" do
        dossier.save
        html = <<-EOF
<div class="alert alert-error alert-block dossier-errors">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <h4>Des erreurs ont été trouvées, vérifiez :</h4>
  <ul>
    <li>Le Nom patiente doit être rempli(e)</li>
    <li>Le Date d'appel doit être rempli(e)</li>
    <li>Le Centre doit être rempli(e)</li>
    <li>Le Témoin doit être rempli(e)</li>
    <li>Le Relance doit être rempli(e)</li>
    <li>Le N° d'appel doit être rempli(e)</li>
    <li>Vous devez saisir au moins 1 produit</li>
  </ul>
EOF
      html << "</div>"
      helper.errors_for(dossier).should == html
      end
    end
  end
end
