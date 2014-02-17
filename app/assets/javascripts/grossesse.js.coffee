class @Grossesse
  constructor: (date_appel, date_dernieres_regles="", date_debut_grossesse="", date_accouchement_prevu="", date_reelle_accouchement="") ->
    @date_appel = date_appel
    @date_dernieres_regles = date_dernieres_regles
    @date_debut_grossesse = date_debut_grossesse
    @date_accouchement_prevu = date_accouchement_prevu
    @date_reelle_accouchement = date_reelle_accouchement

  get_date_debut_grossesse: ->
    return @date_debut_grossesse unless isNaN(parse_fr_date(@date_debut_grossesse).getTime())
    if (ddr = parse_fr_date(@date_dernieres_regles)) and !isNaN(ddr.getTime())
      date = ddr
      days = 14
    else if (dap = parse_fr_date(@date_accouchement_prevu)) and !isNaN(dap.getTime())
      date = dap
      days = -269

    dg = addDays(date, days)
    return dg

  get_date_accouchement_prevu: ->
    if (ddg = parse_fr_date(@date_debut_grossesse)) and !isNaN(ddg.getTime())
      addDays(ddg, 269)
    else
      if (ddr = parse_fr_date(@date_dernieres_regles)) and !isNaN(ddr.getTime())
        addDays(ddr, 283)
      else
        @date_accouchement_prevu unless isNaN(parse_fr_date(@date_accouchement_prevu).getTime())

  age_grossesse: ->
    date_appel = parse_fr_date(@date_appel)
    if isNaN(date_appel.getTime())
      return ""
    else
      # if dg is valid and dap or ddr are also valid use dg to calculate
      if ((dg = parse_fr_date(@date_debut_grossesse)) and !isNaN(dg.getTime())) and ((ddr = parse_fr_date(@date_dernieres_regles)) and !isNaN(ddr.getTime()) or ((dap = parse_fr_date(@date_accouchement_prevu)) and !isNaN(dap.getTime())))
        date = parse_fr_date(addDays(dg, -14))
      else
        if (ddr = parse_fr_date(@date_dernieres_regles)) and !isNaN(ddr.getTime())
          date = ddr
        else if (dg = parse_fr_date(@date_debut_grossesse)) and !isNaN(dg.getTime())
          date = parse_fr_date(addDays(dg, -14))
        else if (dap = parse_fr_date(@date_accouchement_prevu)) and !isNaN(dap.getTime())
          date = parse_fr_date(addDays(dap, -283))

      sa = getSA(date, date_appel)
      return sa

  terme_naissance: ->
    parsed_date_dg = parse_fr_date(@date_debut_grossesse)
    date_ra = parse_fr_date(@date_reelle_accouchement)
    message = "calcul terme naissance impossible car date "
    return message + "de début de grossesse vide" if isNaN(parsed_date_dg.getTime())
    return message + "réelle d'accouchement vide" if isNaN(date_ra.getTime())
    date_dg = parse_fr_date addDays(parsed_date_dg, -14)
    getSA(date_dg, date_ra)

$.fn.resetDates = ->
  @each ->
    $(this).click ->
      $(this).closest(".input-group").find("input").val("")

$.fn.calculateGrossesse = ->
  @each ->
    $(this).blur ->
      # ensure date_appel isnt empty
      if date_appel = $("#dossier_date_appel").val()
        date_dernieres_regles = if (value = $('#dossier_date_dernieres_regles').val()) then value else ""
        date_debut_grossesse = if (value = $('#dossier_date_debut_grossesse').val()) then value else ""
        date_accouchement_prevu = if (value = $('#dossier_date_accouchement_prevu').val()) then value else ""

        # ensure all dates are not empty
        if !date_dernieres_regles and !date_debut_grossesse and !date_accouchement_prevu
          $("#grossesse_date_messages").
            html("<span class='calc_error'>Calcul des dates de grossesse impossible, veuillez saisir au moins la date de dernières règles, de début grossesse ou date prévue d'accouchement.</span>")
        else
          grossesse = new Grossesse(date_appel, date_dernieres_regles, date_debut_grossesse, date_accouchement_prevu)
          $('#dossier_date_dernieres_regles').val(grossesse.date_dernieres_regles)
          $('#dossier_date_debut_grossesse').val(grossesse.get_date_debut_grossesse())
          $('#dossier_date_accouchement_prevu').val(grossesse.get_date_accouchement_prevu())
          $('#dossier_age_grossesse').val(grossesse.age_grossesse())
          $("#grossesse_date_messages").html("&nbsp;")
      else
        $("#grossesse_date_messages").
          html("<span class='calc_error'>Calcul des dates de grossesse impossible, date appel vide</span>")

$.fn.calculateTermeNaissance = ->
  $(@).blur ->
    $terme = $("#dossier_terme")
    terme = new Grossesse("", "", $("#dossier_date_debut_grossesse").val(), "", $(@).val()).terme_naissance()
    field.parents(".form-group").removeClass("has-error") for field in [$terme, $(@)]
    $terme.next("p.help-block").remove()
    unless $terme.val().length? and $terme.val().length > 0
      if terme.length? and terme.length > 0
        field.parents(".form-group").addClass("has-error") for field in [$terme, $(@)]
        $terme.parents(".form-group").append("<p class='help-block'>#{terme}</p>")
      else
        $terme.val(terme)
