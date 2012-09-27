# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  initDossiersDatatable()
  initDossierDialog()
  initComboboxAutocomplete()
  disableSubmitWithEnter()

  $(".combobox").combobox()


  # bootstrap form tabs
  $(".nav-tabs a:first").tab('show')

  $("#codedossier").on "keyup", ->
    value = $(this).val()
    $(this).val(value.toUpperCase())

  $("#dossier_code").on "blur", ->
    value = $(this).val()
    $(this).val(value.toUpperCase())

  $("#dossier_code").mask("aa9999999")

  dates_grossesse_fields = []
  dates_grossesse_fields.push($("#dossier_date_#{field_name}")) for field_name in ["appel", "dernieres_regles", "debut_grossesse", "accouchement_prevu", "reelle_accouchement", "naissance", "recueil_evol"]

  for date_field in dates_grossesse_fields
    date_field.mask("99/99/9999")
    value = date_field.attr("data-value")
    date_field.val(value) if value

  # calc imc
  $("#dossier_#{field}").calculateBMI() for field in ["taille", "poids"]

  #### Grossesse
  $("#dossier_grsant").on 'blur', ->
    grsant = $(this).val()
    if grsant is "0" then zero_grossesse_fields()

  for field in ["antecedents_perso", "antecedents_fam", "toxiques", "folique", "patho1t"]
    element = $("#dossier_#{field}")
    condition = element.val() is "0"
    next = if field is "antecedents_perso" or "antecedents_fam" then element.next() else element.parents(".control-group").next()
    showNextif condition, element, next
    element.on 'change', ->
      condition = $(this).val() is "0"
      next = if field is "antecedents_perso" or "antecedents_fam" then $(this).next() else $(this).parents(".control-group").next()
      showNextif(condition, $(this), next)

  # reminder to fill expositions if tabac/alcool/toxiques equals "Oui"
  $tabac_element = $("select#dossier_tabac")
  $tabac_message = $tabac_element.nextAll(".help-block").hide()
  tabac = $tabac_element.val()
  tabac_condition = tabac and tabac in ["1", "2", "3"]
  showNextif tabac_condition, $tabac_element, $tabac_message
  $("input#dossier_tabac").bind 'autocompleteselect', (event, ui) ->
    tabac_values = ["0 à 5 cig/j", "5 à 10 cig/j", "Sup. à 10 cig/j"]
    tabac = ui.item.value
    condition = tabac and tabac in tabac_values
    console.log condition
    console.log this
    next = $(this).parent().nextAll(".help-block")
    showNextif condition, $(this), next

  $alcool_element = $("select#dossier_alcool")
  $alcool_message = $alcool_element.nextAll(".help-block").hide()
  alcool = $alcool_element.val()
  alcool_condition = alcool and alcool in ["1", "2"]
  showNextif alcool_condition, $alcool_element, $alcool_message
  $("input#dossier_alcool").bind 'autocompleteselect', (event, ui) ->
    alcool_values = ["Occasionnel (<= 2 verres/j)", "Fréquent (> 2 verres/j)"]
    alcool = ui.item.value
    condition = alcool and alcool in alcool_values
    next = $(this).parent().nextAll(".help-block").hide()
    showNextif condition, $(this), next

  # calculateur dates
  $("#dossier_date_naissance").on 'blur', ->
    unless $("#dossier_age").val()
      date_naissance = parse_fr_date($(this).val())
      date_appel = parse_fr_date($("#dossier_date_appel").val())
      $("#dossier_age").val(getYears(date_naissance, date_appel))

  $(".calc_dates_grossesse").calculateGrossesse()
  $(".clear_date").resetDates()

  #exposition dates calculations
  $(".date_expo").hide()
  $("form").on 'click', ".calendar", (e) ->
    e.preventDefault()
    sa_field = $(this).prev()
    date_field = $(this).next()
    date_field.mask("99/99/9999")
    date_field.toggle()
    date_field.focus()
    date_field.one 'blur', ->
      date_expo = parse_fr_date($(this).val())
      ddr = parse_fr_date($('#dossier_date_dernieres_regles').val())
      if !isNaN(date_expo.getTime()) and !isNaN(ddr.getTime())
        sa_field.val(getSA(ddr, date_expo))
        console.log $(this)
        $(this).toggle()

  $("form").on 'blur', ".duree", (e)  ->
    de = $(this).parent().prev().find(".de").val()
    de2 = $(this).val()
    result = de2 - de
    $(this).parents(".control-group").next().find("input").val(de2 - de) if !isNaN(result) and result > 0


  #### Evolution ####
  $accouchement_div = $("#accouchement")
  $evolution_element = $("#dossier_evolution")
  evolution = $evolution_element.val()

  showNextif evolution and evolution in ["2", "3", "4", "5"], $evolution_element

  $accouchement_div.show() if evolution and evolution is "6"

  $evolution_element.on 'change', ->
    evolution = $(this).val()
    showNextif evolution and evolution in ["2", "3", "4", "5"], $(this)
    condition = evolution is "6"
    if condition then $accouchement_div.show() else $accouchement_div.hide()

  #### Correspondant ####
  if $("#correspondant_modal").length
    $("#dossier_correspondant_id_field .btn").hide()
  else
    $("#dossier_correspondant_id_field").remoteForm()

  $new_correspondant_btn = $(".create")
  $edit_correspondant_btn = $(".update")

  # disactivate edit correspondant by default
  $edit_correspondant_btn.hide()

  # activate edit correspondant if dossier_correspondant_id is prefilled
  correspondant_id = $("#dossier_correspondant_id").val()
  activateCorrespondantEdit(correspondant_id) if correspondant_id

  $correspondant_autocomplete = $("#dossier_correspondant_nom")
  # activate edit correspondant when correspondant autocomplete item is selected
  $correspondant_autocomplete.bind "railsAutocomplete.select", (e, data) ->
    correspondant_id = data.item.id
    activateCorrespondantEdit(correspondant_id) if correspondant_id

# functions
zero_grossesse_fields = ->
  fields = []
  fields.push($("#dossier_#{field_name}")) for field_name in ["fcs", "geu", "miu", "ivg", "img", "nai"]
  field.val("0") for field in fields

activateCorrespondantEdit = (correspondant_id) ->
  $edit_correspondant_btn = $(".update")
  $edit_correspondant_btn.attr("data-link", "/correspondants/#{correspondant_id}/edit")
  $edit_correspondant_btn.show()
