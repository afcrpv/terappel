class @Bmi
  constructor: (weight, size) ->
    @weight = weight
    @size = size/100

  calculate: ->
    if @weight and @size
      Math.floor(@weight / (Math.pow(@size, 2)))
    else
      0

$.fn.calculateBMI = ->
  @each ->
    $(this).blur ->
      weight = $("#dossier_poids").val()
      size = $("#dossier_taille").val()
      bmi = new Bmi(weight, size)
      $("#dossier_imc").val(bmi.calculate())
