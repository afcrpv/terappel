class Dossier < ActiveRecord::Base
  #accessible attributes
  attr_accessible :date_appel, :centre_id, :user_id, :code,
    :correspondant_id, :a_relancer, :relance_counter,
    :evolution_id, :categoriesp_id, :motif_id, :mod_accouch_id,
    :date_dernieres_regles, :date_reelle_accouchement, :date_accouchement_prevu, :date_debut_grossesse,
    :name, :prenom, :age, :antecedents_perso, :antecedents_fam, :ass_med_proc, :expo_terato,
    :tabac, :alcool, :fcs, :geu, :miu, :ivg, :nai, :age_grossesse,
    :terme, :path_mat,
    :comm_antecedents_perso, :comm_antecedents_fam, :comm_evol, :comm_expo, :commentaire

  extend FriendlyId
  friendly_id :code

  # readers
  attr_reader :correspondant_name

  # validations
  validates_presence_of :code, :name, :date_appel, :centre_id, :user_id
  #TODO: add more required field

  #associations
  belongs_to :centre
  belongs_to :user

  #delegations
  delegate :name, :code, :to => :centre, :prefix => true
  delegate :username, :to => :user, :allow_nil => true

  #custom methods
end
