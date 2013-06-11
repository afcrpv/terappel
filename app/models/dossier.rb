#encoding: utf-8
class Dossier < ActiveRecord::Base
  # Constants
  ONI = %w(Oui Non NSP)
  TABAC = [["Non", "0"], ["0 à 5 cig/j", "1"], ["5 à 10 cig/j", "2"], ["Sup. à 10 cig/j", "3"], ["NSP", "4"]]
  ALCOOL = [["Non", "0"], ["Occasionnel", "1"], ["Régulier", "2"], ["NSP", "3"]]
  MODACCOUCH = [["V-b spontanée", "0"], ["V-b instrumentale", "1"], ["Césarienne", "2"], ["Inconnue", "3"]]
  EVOLUTION = [["GEU", 1], ["FCS", 2], ["IVG", 3], ["IMG", 4], ["MIU", 5], ["NAI", 6], ["INC", 7], ["GNC", 8]]
  COLUMNS_FOR_CSV = [:code, :date_appel, :motif_code, :produit1, :produit2, :evolution, :malformation, :pathologie ]

  # validations
  validates_presence_of :name, :date_appel, :centre_id, :expo_terato, :a_relancer
  validates :code, uniqueness: true, presence: true
  validate :must_have_produits

  #associations
  belongs_to :centre
  belongs_to :user
  belongs_to :motif
  has_one :demandeur
  accepts_nested_attributes_for :demandeur, reject_if: :all_blank
  has_one :relance
  accepts_nested_attributes_for :relance, reject_if: :all_blank
  belongs_to :categoriesp

  has_many :produits, through: :expositions
  has_many :expositions, dependent: :destroy
  accepts_nested_attributes_for :expositions, reject_if: :all_blank, allow_destroy: true
  has_many :bebes, dependent: :destroy
  accepts_nested_attributes_for :bebes, reject_if: :all_blank, allow_destroy: true

  #delegations
  delegate :name, :code, to: :centre, prefix: true
  delegate :name, :code, to: :motif, prefix: true, allow_nil: true
  delegate :name, to: :categoriesp, prefix: true, allow_nil: true
  delegate :username, to: :user, allow_nil: true

  # methods

  def to_param
    code
  end

  def localized_dateappel
    I18n.l(date_appel) if date_appel
  end
  def patiente_fullname
    [self.try(:name).upcase, self.try(:prenom)].join(" ")
  end

  def produits_names
    if produits.any?
      produits.map(&:name).to_sentence
    end
  end

  def code_and_id
    {id: id, text: code}
  end

  private

  def must_have_produits
    if expositions.empty? or expositions.all? {|exposition| exposition.marked_for_destruction? }
      errors.add(:base, "vous devez saisir au moins 1 produit")
    end
  end
end
