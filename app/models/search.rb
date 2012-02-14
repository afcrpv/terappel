class Search < ActiveRecord::Base
  attr_accessible :centre_id, :min_date_appel, :max_date_appel, :motif_id, :expo_nature_id, :expo_type_id, :indication_id, :expo_terme_id, :evolution_id, :malformation, :pathologie, :indication_name

  attr_writer :indication_name

  def find_dossiers
    dossiers = Dossier.includes(:centre, :motif, :expositions, :evolution)
    dossiers = dossiers.where(centre_id: centre_id) if centre_id.present?
    dossiers = dossiers.where(motif_id: motif_id) if motif_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_nature_id' => expo_nature_id) if expo_nature_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_type_id' => expo_type_id) if expo_type_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.expo_terme_id' => expo_terme_id) if expo_terme_id.present?
    dossiers = dossiers.joins(:expositions).where('expositions.indication_id' => indication_id) if indication_id.present?
    dossiers = dossiers.where(evolution_id: evolution_id) if evolution_id.present?
    dossiers = dossiers.where(malformation: malformation) if malformation.present?
    dossiers = dossiers.where(pathologie: pathologie) if pathologie.present?
    dossiers = dossiers.where("date_appel >= ?", min_date_appel) if min_date_appel.present?
    dossiers = dossiers.where("date_appel <= ?", max_date_appel) if max_date_appel.present?
    dossiers
  end

  def indication_name
    Indication.find(indication_id).name if indication_id
  end
end
