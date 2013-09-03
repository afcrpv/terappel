#encoding: utf-8
class DossiersPdf < Prawn::Document
  def initialize dossiers, view
    super top_margin: 20
    @dossiers = dossiers
    @view = view
    header
    move_down 10
    dossiers_table
  end

  def header
    text "Liste dossiers"
  end

  def dossiers_table
    data = []
    data << ["N° Dossier", "Date Appel", "Patiente", "Motif", "Exposition", "Evolution", "Malf", "Path"]
    @dossiers.each do |d|
      data << [d.code, d.date_appel, d.name, d.motif_code, d.expositions(false), d.evolution, d.malformation, d.pathologie]
    end

    font_size 10 do
      table data, header: true, width: 580, position: :center, column_widths: {0 => 70, 1 => 70, 2 => 80, 3 => 40, 5 => 60, 6 => 40, 7 => 40} do
        cells.style do |cell|
          cell.border_width = 0
          cell.valign = :center
        end
        row(0).borders = [:bottom]
        row(0).border_width = 2
        row(0).font_style = :bold
      end
    end
  end


end
