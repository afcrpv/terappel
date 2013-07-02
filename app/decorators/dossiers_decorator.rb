require "csv"
class DossiersDecorator < Draper::CollectionDecorator
  COLUMNS_FOR_CSV = [:code, :date_appel, :motif_code, :age, :grsant, :fcs, :geu, :miu, :ivg, :img, :nai, :tabac, :alcool, :age_grossesse, :produit1, :produit2, :produit3, :indication, :dose, :expo_terme, :de, :a, :de2, :a2, :evolution, :terme, :modaccouch, :nbr_bebes, :sexe, :poids, :taille, :pc, :apgar1, :apgar5, :malformation, :pathologie, :a_relancer]

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << COLUMNS_FOR_CSV.map {|column| object.human_attribute_name(column) }
      object.all.each do |dossier|
        csv << COLUMNS_FOR_CSV.map {|column| DossierDecorator.decorate(dossier).send(column) }
      end
      csv
    end
  end
end
