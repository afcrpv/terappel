class DossierPdf < Prawn::Document
  def initialize dossier, view
    super(top_margin: 30)
    @view = view
    @dossier = view.present(dossier)
    header

    my_table info_generales, "Info générales"
    my_table correspondant, "Correspondant"
    my_table patiente, "Patiente"
    my_table grossesse, "Grossesse en cours"
    #commentaire
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

  def my_table(data, heading)
    table_heading heading
    font_size 10 do
      table data, position: :center, width: 580 do
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

  def atcds
    [
    ]
  end

  def grossesse
    [["Age grossesse lors appel : ", @dossier.age_grossesse, "Début grossesse", @dossier.date_debut_grossesse, "Accouchement prévu", @dossier.date_accouchement_prevu]]
  end

  def incrimines
    data = []
    @dossier.incrimines.each do |inc|
      data << [{content: inc.medicament.to_s.titleize, colspan: 5}, {content: inc.full_indication, colspan: 4}, {content: inc.duree_ttt, colspan: 3}]
    end
    move_down 20
    text "Médicaments en cause", size: 10, style: :bold
    font_size(10) do
      table data, position: :center, width: 560 do
        cells.style do |cell|
          cell.borders = [:top, :bottom]
          cell.valign = :center
        end
      end
    end
  end

  def contraception_apres_evenement
    move_down 20
    text "Contraception après l'évènement", size: 10, style: :bold
    data = [
      ["Contre-indication : ", @dossier.contraception_ci(false), "Reprise d'une contraception : ", @dossier.contraception_apres(false)]
    ]
    font_size(10) do
      table data, position: :center, width: 560 do
        cells.style do |cell|
          cell.borders = [:top, :bottom]
          cell.valign = :center
          if cell.column.even?
            cell.align = :right
            cell.font_style = :bold
          end
        end
      end
    end
  end

  def fdr
    move_down 20
    text "Facteurs de risque", size: 10, style: :bold
    liste_fdr = [
      {label: "Communs", value: @dossier.fdr_communs},
      {label: "Veineux", value: @dossier.fdr_veineux},
      {label: "Artériels", value: @dossier.fdr_arteriels},
    ]
    data = []
    liste_fdr.each do |item|
      data << [item[:label] + " :", {content: item[:value], colspan: 5}]
    end
    font_size(10) do
      table data, position: :center, width: 560 do
        cells.style do |cell|
          cell.borders = [:top, :bottom]
          cell.valign = :center
          if cell.column.even?
            cell.align = :right
            cell.font_style = :bold
          end
        end
      end
    end
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
