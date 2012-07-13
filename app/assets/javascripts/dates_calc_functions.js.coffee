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
  if typeof string is 'string'
    adata = string.split("/")
    gg = parseInt(adata[0],10)
    mm = parseInt(adata[1],10)
    aaaa = parseInt(adata[2],10)
    xdata = new Date(aaaa,mm-1,gg)
