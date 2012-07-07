jQuery.validator.addMethod(
  "dateNotFuture"
  (value, element) ->
    check = false
    today = Date.now()
    date_to_test = parse_fr_date(value)
    check = true if date_to_test.getTime() <= today
    return this.optional(element) || check
  "Cette date est dans le futur"
)

jQuery.validator.addMethod(
  "dateAPvsRA"
  (value, element) ->
    check = false
    dra = parse_fr_date value
    dap = parse_fr_date $("#dossier_date_accouchement_prevu").val()
    semaine = 1000 * 60 * 60 * 24 * 7
    dap_moins_8semaines = dap.getTime() - (semaine * 8)
    dap_plus_4semaines = dap.getTime() + (semaine * 4)
    check = true if dra.getTime() > dap_moins_8semaines and dra.getTime() < dap_plus_4semaines
    return this.optional(element) || check
  "La date réelle d'accouchement est en dehors de l'intervalle Date prévue d'accouchement -8 semaines et Date prévue d'accouchement +4 semaines"
)

jQuery.validator.addMethod(
  "dateITA"
  (value, element) ->
    check = false
    re = /^\d{1,2}\/\d{1,2}\/\d{4}$/
    if re.test(value)
      adata = value.split('/')
      gg = parseInt(adata[0],10)
      mm = parseInt(adata[1],10)
      aaaa = parseInt(adata[2],10)
      xdata = new Date(aaaa,mm-1,gg)
      if xdata.getFullYear() is aaaa  && xdata.getMonth() is mm - 1  && xdata.getDate() is gg
        check = true
      else
        check = false
    else
      check = false
    return this.optional(element) || check
  "Entrez une date valide"
)
