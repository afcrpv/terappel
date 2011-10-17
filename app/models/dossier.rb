class Dossier < ActiveRecord::Base
  attr_accessible :name, :date_appel, :code, :centre_id

  extend FriendlyId
  friendly_id :code

  validates_presence_of :name, :date_appel
  belongs_to :centre
  belongs_to :user

  delegate :name, :code, :to => :centre, :prefix => true

  after_create :assign_code
  before_update do
    self.code = create_code
  end

  def year
    date_appel.beginning_of_year.year.to_s
  end

  def year_index
    if dossiers_years[year].nil?
      1
    else
      dossiers_years[year].index(self) + 1
    end
  end

  def dossiers_years
    dossiers = centre.dossiers
    dossiers.group_by { |dossier| dossier.year }
  end

  private

  def assign_code
    self.update_attribute(:code, create_code)
  end

  def create_code
    [centre_code.upcase,
    "-",
    year,
    "-",
    year_index].join
  end
end
