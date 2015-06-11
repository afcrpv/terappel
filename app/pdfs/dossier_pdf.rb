class DossierPdf < Prawn::Document
  def initialize dossier, decorated_dossier, view
    super(top_margin: 30)
    @view = view
    @dossier_object = dossier
    @dossier = decorated_dossier
    header

    my_table info_generales, "Info générales"
    my_table correspondant, "Correspondant"
    my_table patiente, "Patiente"
    my_table grossesse, "Grossesse en cours"

    table_heading "Expositions"
    font_size 10 do
      table expositions, position: :center do
        cells.style do |cell|
          cell.border_width = 0
          cell.valign = :center
        end
        row(0).borders = [:bottom]
        row(0).border_width = 1
        row(0).font_style = :bold
      end
    end
    move_down 10

    my_table evolution, "Evolution"

    table_heading "Nouveau(x) né(s)"
    font_size 10 do
      table bebes, position: :center do
        cells.style do |cell|
          cell.border_width = 0
          cell.valign = :center
        end
        row(0).borders = [:bottom]
        row(0).border_width = 1
        row(0).font_style = :bold
      end
    end
    move_down 10

    commentaire
  end

  def header
    text "Dossier #{@dossier.code}", size: 14, style: :bold
    move_down 10
  end

  def table_heading(text_data)
    stroke_horizontal_rule
    pad(5) { text text_data, style: :bold, align: :center }
    stroke_horizontal_rule
  end

  def my_table(data, heading, options={})
    options = options.merge position: :center, width: 580 unless options.any?
    table_heading heading
    font_size 10 do
      table data, options do
        cells.style do |cell|
          cell.border_width = 0
          cell.valign = :center
          if cell.column.even?
            cell.align = :right
            cell.font_style = :bold
          end
        end
      end
    end
    move_down 10
  end

  def info_generales
    [["Date Appel :", @dossier.date_appel, "Motif :", @dossier.motif_name, "Témoin :", @dossier.expo_terato]]
  end

  def correspondant
    relance_label, relance_content = "", ""
    if @dossier.a_relancer == "Oui"
      relance_label = "A relancer :"
      relance_content = @dossier.relance.to_s
    end
    data = []
    data << ["Initial :", {content: @dossier.demandeur.to_s, colspan: 5}]
    data << [relance_label, {content: relance_content, colspan: 5}]
  end

  def patiente
    [
      ["Données démographiques :", {content: @dossier.patiente + ", " + @dossier.patient_data, colspan: 5}],
      ["Antécédents personnels :", {content: @dossier.atcds_perso, colspan: 5}],
      ["Antécédents familiaux :", {content: @dossier.atcds_fam, colspan: 5}],
      ["Nb grossesse(s) antérieure(s) :", {content: @dossier.atcds_grs, colspan: 5}]
    ]
  end

  def grossesse
    [
      ["Age grossesse lors appel :", @dossier.age_grossesse, "Début grossesse :", @dossier.date_debut_grossesse, "Accouchement prévu :", @dossier.date_accouchement_prevu],
      ["Tabac :", @dossier.tabac, "Alcool :", @dossier.alcool, "Autres toxiques :", @dossier.toxiques],
      ["Acide folique :", @dossier.folique, "Pathologie(s) T1 :", @dossier.patho1t, "AMP :", @dossier.ass_med_proc]
    ]
  end

  def evolution
    [
      ["Date recueil :", @dossier.date_recueil_evol, "Evolution :", @dossier.evolution.to_s, "Terme :", @dossier.terme, "Date accouchement :", @dossier.date_reelle_accouchement]
    ]
  end

  def expositions
    data = [["Produit", "Indication", "Posologie", "Terme"]]
    @dossier_object.expositions.each do |expo|
      data << [expo.produit.to_s, expo.indication.to_s, expo.expo_terme.to_s, expo.dose]
    end
    data
  end

  def bebes
    data = [["Age", "Sexe", "Poids", "Taille", "PC", "Apgar", "Malf", "Path"]]
    @dossier_object.bebes.each do |bebe|
      data << [bebe.age, bebe.sexe, bebe.poids, bebe.taille, bebe.pc, bebe.apgar, bebe.malformation, bebe.pathology]
    end
    data
  end

  def commentaire
    font_size 10 do
      move_down 20
      text "Commentaire", style: :bold
      move_down 10
      text @dossier.commentaire(false)
    end
  end
end
