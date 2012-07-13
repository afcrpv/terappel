class @Grossesse
  constructor: (date_appel, date_dernieres_regles="", date_debut_grossesse="", date_accouchement_prevu="") ->
    @date_appel = date_appel
    @date_dernieres_regles = date_dernieres_regles
    @date_debut_grossesse = date_debut_grossesse
    @date_accouchement_prevu = date_accouchement_prevu

  get_date_debut_grossesse: ->
    return @date_debut_grossesse unless isNaN(parse_fr_date(@date_debut_grossesse).getTime())
    ddr = parse_fr_date(@date_dernieres_regles)
    addDays(ddr, 14) unless isNaN(ddr.getTime())

  get_date_accouchement_prevu: ->
    return @date_accouchement_prevu unless isNaN(parse_fr_date(@date_accouchement_prevu).getTime())
    ddg = parse_fr_date(@date_debut_grossesse)
    addDays(ddg, 269) unless isNaN(ddg.getTime())

  age_lors_appel: (string) ->
    date_appel = parse_fr_date(@date_appel)
    date = parse_fr_date(string)
    if isNaN(date.getTime())
      console.log "date parsed from '#{string}' is invalid"
      return null
    else
      getSA(date, date_appel)

$.fn.calculateGrossesse = ->
  @each ->
    $(this).blur ->

window.calc_date_grossesse = ->
  date_appel            = parse_fr_date($('#dossier_date_appel').val())
  date_dernieres_regles = parse_fr_date($('#dossier_date_dernieres_regles').val())
  date_debut_grossesse  = parse_fr_date($('#dossier_date_debut_grossesse').val())
  date_accouchement_prevu = parse_fr_date($('#dossier_date_accouchement_prevu').val())

  # ensure date_appel isnt empty or invalid
  if isNaN(date_appel.getTime())
    $("#grossesse_date_messages").html("<span class='calc_error'>Calcul impossible, date appel vide</span>")
  else
    # ensure date_dernieres_regles isnt empty or invalid
    if isNaN(date_dernieres_regles.getTime())
      # ensure date_debut_grossesse isnt empty or invalid
      if isNaN(date_debut_grossesse.getTime())
        # ensure date_accouchement_prevu isnt empty or invalid
        if isNan(date_accouchement_prevu.getTime())
          $("#grossesse_date_messages").html("<span class='calc_error'>Calcul impossible, veuillez saisir au moins la date de dernières règles, de début grossesse ou date prévue d'accouchement.</span>")
        else# date_accouchement_prevu is valid
      else# date_debut_grossesse is valid
        # calculate date_accouchement_prevu from date_debut_grossesse
        $("#grossesse_date_messages").html("")
        date_acc_prev_string  = addDays(parse_fr_date($('#dossier_date_debut_grossesse').val()), 269)
        $('#dossier_date_accouchement_prevu').val(date_acc_prev_string)
    else
      # calculate date_debut_grossesse, date_accouchement_prevu and age_grossesse
      $("#grossesse_date_messages").html("")
      # ensure fields ddr and date_appel are not empty
      $('#dossier_age_grossesse').val(getSA(parse_fr_date($('#dossier_date_dernieres_regles').val()), date_appel))
      date_debut_grs_string = addDays(parse_fr_date($('#dossier_date_dernieres_regles').val()), 14)
      date_acc_prev_string  = addDays(parse_fr_date($('#dossier_date_dernieres_regles').val()), 283)
      $('#dossier_date_debut_grossesse').val(date_debut_grs_string)
      $('#dossier_date_accouchement_prevu').val(date_acc_prev_string)

addDays = (objDate, days) ->
  strSep = "/"
  # add days to date object
  objDate.setDate(objDate.getDate() + days)
  # parse string for the modified date object
  arrDate = []
  gg = objDate.getDate()
  gg = if gg.toString().length is 2 then gg else "0" + gg
  mm = objDate.getMonth() + 1
  mm = if mm.toString().length is 2 then mm else "0" + mm
  aaaa = objDate.getFullYear()
  arrDate.push(gg, mm, aaaa)
  arrDate.join(strSep)
