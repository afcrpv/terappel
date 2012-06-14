#encoding: utf-8
class Dossier < ActiveRecord::Base
  #accessible attributes
  attr_accessible :date_appel, :centre_id, :user_id, :code,
    :correspondant_id, :a_relancer, :relance_counter,
    :correspondant_nom,
    :categoriesp_id, :motif_id, :modaccouch,
    :date_dernieres_regles, :date_reelle_accouchement, :date_accouchement_prevu, :date_debut_grossesse, :date_recueil_evol,
    :name, :prenom, :age, :antecedents_perso, :antecedents_fam, :ass_med_proc, :expo_terato,
    :tabac, :alcool, :fcs, :geu, :miu, :ivg, :img, :nai, :grsant, :age_grossesse,
    :terme, :path_mat,
    :comm_antecedents_perso, :comm_antecedents_fam, :comm_evol, :comm_expo, :commentaire,
    :expositions_attributes, :bebes_attributes, :toxiques, :date_naissance, :poids, :taille, :folique, :patho1t, :evolution

  # Constants
  ONI = [["Oui", "0"], ["Non", "1"], ["NSP", "2"]]
  TABAC = [["Non", "0"], ["0 à 5 cig/j", "1"], ["5 à 10 cig/j", "2"], ["Sup. à 10 cig/j", "3"], ["NSP", "4"]]
  ALCOOL = [["Non", "0"], ["Occasionnel (<= 2 verres/j)", "1"], ["Fréquent (> 2 verres/j)", "2"], ["NSP", "3"]]
  MODACCOUCH = [["V-b spontanée", "0"], ["V-b instrumentale", "1"], ["Césarienne", "2"], ["Inconnue", "3"]]
  EVOLUTION = [["GEU", 1], ["FCS", 2], ["IVG", 3], ["IMG", 4], ["MIU", 5], ["NAI", 6], ["INC", 7], ["GNC", 8]]

  # writers
  attr_writer :correspondant_nom

  extend FriendlyId
  friendly_id :code

  # validations
  validates_presence_of :code, :name, :date_appel, :centre_id, :user_id
  #TODO: add more required field

  #associations
  belongs_to :centre
  belongs_to :user
  belongs_to :motif
  belongs_to :correspondant
  belongs_to :categoriesp

  has_many :produits, through: :expositions
  has_many :expositions, :dependent => :destroy
  accepts_nested_attributes_for :expositions, :reject_if => :all_blank, :allow_destroy => true
  has_many :bebes, :dependent => :destroy
  accepts_nested_attributes_for :bebes, :reject_if => :all_blank, :allow_destroy => true

  #delegations
  delegate :name, :code, :to => :centre, :prefix => true
  delegate :name, :code, :to => :motif, :prefix => true, allow_nil: true
  delegate :name, :to => :categoriesp, :prefix => true, allow_nil: true
  delegate :username, :to => :user, :allow_nil => true
  delegate :fullname, :to => :correspondant, :prefix => true, :allow_nil => true
  delegate :ville, to: :correspondant, prefix: true, allow_nil: true

  def localized_dateappel
    I18n.l(date_appel) if date_appel
  end
  def patiente_fullname
    [self.try(:name).upcase, self.try(:prenom)].join(" ")
  end

  def correspondant_nom
    self.try(:correspondant_fullname)
  end

  def produits_names
    if produits.any?
      produits.map(&:name).to_sentence
    end
  end
end
