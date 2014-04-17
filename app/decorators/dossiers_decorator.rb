require "csv"
class DossiersDecorator < Draper::CollectionDecorator
  COLUMNS_FOR_CSV = [:code, :date_appel, :motif_code, :age, :poids, :taille, :atcds_fam, :atcds_perso, :grsant, :fcs, :geu, :miu, :ivg, :img, :nai, :tabac, :alcool, :age_grossesse, :evolution, :terme, :modaccouch, :nbr_bebes, :bb1_sexe, :bb1_poids, :bb1_taille, :bb1_pc, :bb1_apgar1, :bb1_apgar5, :malformation, :pathologie, :a_relancer]

  (1..3).each do |i|
    %w(produit indication dose expo_terme de a de2 a2).each do |name|
      COLUMNS_FOR_CSV << :"#{name}_#{i}"
    end
  end

  COLUMNS_FOR_CSV << :commentaire

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << COLUMNS_FOR_CSV.map {|column| object.human_attribute_name(column) }
      object.load.each do |dossier|
        columns = COLUMNS_FOR_CSV.map do |column|
          decorated_column = column == :commentaire ? DossierDecorator.decorate(dossier).send(column, false) : DossierDecorator.decorate(dossier).send(column)
          decorated_column.present? ? decorated_column : ""
        end
        csv << columns
      end
      csv
    end
  end
end
