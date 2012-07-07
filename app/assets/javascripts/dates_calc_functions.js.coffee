window.reset_date_grossesse = ->
  $("#grossesse_date_messages").html("")
  $('#dossier_age_grossesse').val("")
  $('#dossier_date_dernieres_regles').val("")
  $('#dossier_date_debut_grossesse').val("")
  $('#dossier_date_accouchement_prevu').val("")

window.calc_date_grossesse = ->
  date_appel            = parse_fr_date($('#dossier_date_appel').val())
  date_dernieres_regles = parse_fr_date($('#dossier_date_dernieres_regles').val())
  date_debut_grossesse  = parse_fr_date($('#dossier_date_debut_grossesse').val())
  # ensure date_appel isnt empty or invalid
  if isNaN(date_appel.getTime())
    $("#grossesse_date_messages").html("<span class='calc_error'>Calcul impossible, date appel vide</span>")
  else
    # when date_dernieres_regles is empty or invalid
    if isNaN(date_dernieres_regles.getTime())
      # ensure date_debut_grossesse isnt empty or invalid
      if isNaN(date_debut_grossesse.getTime())
        $("#grossesse_date_messages").html("<span class='calc_error'>Calcul impossible, dates dernières règles et debut grossesse vides</span>")
      else
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

window.getSA = (dateDR, dateAppel) ->
  start = dateDR.getTime()
  end = dateAppel.getTime()
  delta = end - start
  days = delta / (1000 * 60 * 60 * 24)
  Math.round(days/7)

window.getYears = (startDate, endDate) ->
  unless isNaN(startDate.getTime()) and isNaN(endDate.getTime())
    start = startDate.getTime()
    end = endDate.getTime()
    delta = end - start
    days = delta / (1000 * 60 * 60 * 24)
    Math.round(days/365)

window.parse_fr_date = (string) ->
  adata = string.split("/")
  gg = parseInt(adata[0],10)
  mm = parseInt(adata[1],10)
  aaaa = parseInt(adata[2],10)
  xdata = new Date(aaaa,mm-1,gg)
