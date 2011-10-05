class Dossier < ActiveRecord::Base
  validates_presence_of :name, :date_appel
  belongs_to :centre
  belongs_to :user

  delegate :name, :code, :to => :centre, :prefix => true

  def code
    [centre_code.upcase,
    "-",
    year,
    "-",
    year_index].join("")
  end

  def year
    date_appel.beginning_of_year.year.to_s
  end

  def year_index
    dossiers_years[year].index(self) + 1
  end

  def dossiers_years
    dossiers = centre.dossiers
    dossiers.group_by { |dossier| dossier.year }
  end
end
