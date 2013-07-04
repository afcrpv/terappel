require "csv"
class DossiersDecorator < Draper::CollectionDecorator
  COLUMNS_FOR_CSV = [:code, :date_appel, :motif_code, :age, :grsant, :fcs, :geu, :miu, :ivg, :img, :nai, :tabac, :alcool, :age_grossesse, :evolution, :terme, :modaccouch, :nbr_bebes, :sexe, :poids, :taille, :pc, :apgar1, :apgar5, :malformation, :pathologie, :a_relancer]

  (1..3).each do |i|
    %w(produit indication posologie terme_expo).each do |name|
        COLUMNS_FOR_CSV << :"#{name}#{i}"
    end
  end
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
