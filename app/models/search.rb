class Search < ActiveRecord::Base
  belongs_to :produit
  belongs_to :indication
  belongs_to :dci

  has_and_belongs_to_many :produits
  has_and_belongs_to_many :dcis

  %w(produit dci).each do |name|
    attr_reader :"#{name}_tokens"

    define_method :"#{name}_tokens=" do |ids|
      self.send(:"#{name}_ids=", ids.split(","))
    end
  end

  def find_dossiers
    dossiers = Dossier.includes({expositions: [:produit, :indication, :expo_terme]}, :centre, :motif, :produits, :bebes)
    dossiers = dossiers.where(centre_id: centre_id) if local?
    dossiers = dossiers.where(motif_id: motif_id) if motif_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_nature_id' => expo_nature_id) if expo_nature_id
    dossiers = dossiers.joins(:expositions).where('expositions.expo_type_id' => expo_type_id) if expo_type_id
    dossiers = dossiers.joins(:expositions).where('expositions.expo_terme_id' => expo_terme_id) if expo_terme_id
    dossiers = dossiers.joins(:expositions).where('expositions.indication_id' => indication_id) if indication_id
    dossiers = dossiers.joins(:expositions).where(expositions: {produit_id: [produit_ids]}) if produit_ids.any?
    dossiers = dossiers.joins(expositions: {produit: :compositions}).where(compositions: {dci_id: [dci_ids]}) if dci_ids.any?
    dossiers = dossiers.where(evolution: evolution) if evolution
    dossiers = dossiers.joins(:bebes).where(bebes: {malformation: malformation}) if malformation.present?
    dossiers = dossiers.joins(:bebes).where(bebes: {pathologie: pathologie}) if pathologie.present?
    dossiers = dossiers.where("date_appel >= ?", min_date_appel) if min_date_appel
    dossiers = dossiers.where("date_appel <= ?", max_date_appel) if max_date_appel
    dossiers.uniq
  end

  def search_params
    result = {}
    result['Type recherche'] = local? ? "Locale (#{Centre.find(centre_id)})" : "Nationale"
    result = result.merge(attributes)
    result['date appel'] = "du " + I18n.l(min_date_appel) + " au " + I18n.l(max_date_appel)
    result['motif'] = Motif.find(motif_id).name if motif_id
    result['produits'] = Produit.find(self.produit_ids).map(&:name).to_sentence(two_words_connector: " ou ", words_connector: " ou ", last_word_connector: " ou ") if produit_ids
    result['dcis'] = Dci.find(self.dci_ids).map(&:libelle).to_sentence(two_words_connector: " ou ", words_connector: " ou ", last_word_connector: " ou ") if dci_ids
    result['expo_nature'] = ExpoNature.find(expo_nature_id).name if expo_nature_id
    result['expo_type'] = ExpoType.find(expo_type_id).name if expo_type_id
    result['expo_terme'] = ExpoTerme.find(expo_terme_id).name if expo_terme_id
    result['indication'] = Indication.find(indication_id).name if indication_id
    result['evolution'] = Evolution.find(evolution).name if evolution
    result = result.delete_if {|k,v| k == "local"}
    result = result.delete_if {|k,v| k =~ /id$/}
    result = result.delete_if {|k,v| %w(max_date_appel min_date_appel).include?(k)}
    result = result.delete_if {|k,v| %w(created_at updated_at).include?(k)}
    result = result.delete_if {|k,v| !v.present?}
    result
  end
end
