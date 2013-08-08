class @Bmi
  constructor: (weight, size) ->
    @weight = weight
    @size = size/100

  calculate: ->
    if @weight and @size
      Math.floor(@weight / (Math.pow(@size, 2)))
    else
      0

$.fn.calculateBMI = (result_container)->
  @each ->
    $(this).blur ->
      weight = $("#dossier_poids").val()
      size = $("#dossier_taille").val()
      if weight and size
        bmi = new Bmi(weight, size)
        $(result_container).val(bmi.calculate())
      else
        $(result_container).val("")
