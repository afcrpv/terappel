$ = jQuery

$ ->
  $(".topbar-search .search-icon").click ->
    $(".topbar-search").submit() if $(".search-query").val()
  $(".alert-message").alert()
  $("[rel=tooltip]").tooltip
    delay:
      hide: 100
  $(".dropdown-toggle").dropdown()

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
