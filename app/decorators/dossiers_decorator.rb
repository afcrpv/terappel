require "csv"
class DossiersDecorator < Draper::CollectionDecorator
  COLUMNS_FOR_CSV = [:code, :date_appel, :motif_code, :produit1, :produit2, :evolution, :malformation, :pathologie]

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
