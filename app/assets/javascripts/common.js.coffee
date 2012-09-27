$ = jQuery

$ ->
  $(".topbar-search .search-icon").click ->
    $(".topbar-search").submit() if $(".search-query").val()
  $(".alert-message").alert()
  $("[rel=tooltip]").tooltip
    delay:
      hide: 100
  $(".dropdown-toggle").dropdown()

$.fn.expo_termes_calc = ->
  $(".date_expo").hide()
  @each ->
    $(this).click (e) ->
      console.log "calendar clicked"
      e.preventDefault()
      sa_field = $(this).prev()
      date_field = $(this).next()
      console.log date_field
      date_field.mask("99/99/9999")
      date_field.toggle()
      date_field.focus()
      date_field.one 'blur', ->
        date_expo = parse_fr_date($(this).val())
        ddr = parse_fr_date($('#dossier_date_dernieres_regles').val())
        if !isNaN(date_expo.getTime()) and !isNaN(ddr.getTime())
          console.log sa_field
          sa_field.val(getSA(ddr, date_expo))
          console.log $(this)
          $(this).toggle()

  $("form").on 'blur', ".duree", (e)  ->
    de = $(this).parent().prev().find(".de").val()
    de2 = $(this).val()
    result = de2 - de
    $(this).parents(".control-group").next().find("input").val(de2 - de) if !isNaN(result) and result > 0


window.disableSubmitWithEnter = ->
  for type in ["text", "number"]
    $("form.saisie input[type='#{type}']").keypress (e) ->
      return false if e.which is 13

window.showNextif = (condition, element, next) ->
  if condition then $(next).show() else $(next).hide()

window.getSA = (dateFrom, dateAppel) ->
  start = dateFrom.getTime()
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
  if typeof string is 'string'
    adata = string.split("/")
    gg = parseInt(adata[0],10)
    mm = parseInt(adata[1],10)
    aaaa = parseInt(adata[2],10)
    xdata = new Date(aaaa,mm-1,gg)

 window.addDays = (objDate, days) ->
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
