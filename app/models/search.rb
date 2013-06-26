class Search < ActiveRecord::Base

  belongs_to :produit
  belongs_to :indication
  belongs_to :dci

  def find_dossiers
    dossiers = Dossier.includes(:centre, :motif, :expositions, :bebes)
    dossiers = dossiers.where(centre_id: centre_id) if centre_id.present?
    dossiers = dossiers.where(motif_id: motif_id) if motif_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_nature_id' => expo_nature_id) if expo_nature_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_type_id' => expo_type_id) if expo_type_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_terme_id' => expo_terme_id) if expo_terme_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.indication_id' => indication_id) if indication_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.produit_id' => produit_id) if produit_id.present?
    dossiers = dossiers.joins(expositions: {produit: :compositions}).where(compositions: {dci_id: dci_id}) if dci_id.present?
    dossiers = dossiers.where(evolution: evolution) if evolution.present?
    dossiers = dossiers.joins(:bebes).where(bebes: {malformation: malformation}) if malformation.present?
    dossiers = dossiers.joins(:bebes).where(bebes: {pathologie: pathologie}) if pathologie.present?
    dossiers = dossiers.where("date_appel >= ?", min_date_appel) if min_date_appel.present?
    dossiers = dossiers.where("date_appel <= ?", max_date_appel) if max_date_appel.present?
    dossiers.uniq
  end

  def search_params
    result = attributes
    result['centre'] = Centre.find(centre_id).name if centre_id
    result['date appel'] = "du " + I18n.l(min_date_appel) + " au " + I18n.l(max_date_appel)
    result['motif'] = Motif.find(motif_id).name if motif_id
    result['exposition'] = Produit.find(produit_id).name if produit_id
    result['expo_nature'] = ExpoNature.find(expo_nature_id).name if expo_nature_id
    result['expo_type'] = ExpoType.find(expo_type_id).name if expo_type_id
    result['expo_terme'] = ExpoTerme.find(expo_terme_id).name if expo_terme_id
    result['indication'] = Indication.find(indication_id).name if indication_id
    result['evolution'] = Evolution.find(evolution).name if evolution
    result = result.delete_if {|k,v| k =~ /id$/}
    result = result.delete_if {|k,v| %w(max_date_appel min_date_appel).include?(k)}
    result = result.delete_if {|k,v| %w(created_at updated_at).include?(k)}
    result = result.delete_if {|k,v| !v.present?}
    result
  end
end
