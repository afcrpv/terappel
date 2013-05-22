# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ = jQuery

$ ->
  $('body').on 'hidden', '.modal', ->
    $(@).removeData('modal')
  disableSubmitWithEnter()

  $(".combobox").select2()

  # bootstrap form tabs
  $(".nav-tabs a:first").tab('show')

  for field in ["code", "name"]
    $("#dossier_#{field}").on "blur", ->
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
  $tabac_input = $("#dossier_tabac")
  tabac_values = ["1", "2", "3"]#["0 à 5 cig/j", "5 à 10 cig/j", "Sup. à 10 cig/j"]
  show_or_hide_hint_for_toxics($tabac_input, $tabac_input.val(), tabac_values)
  $tabac_input.on 'change', (event) -> show_or_hide_hint_for_toxics($(this), event.val, tabac_values)

  $alcool_input = $("#dossier_alcool")
  alcool_values = ["1", "2"]#["Occasionnel (<= 2 verres/j)", "Fréquent (> 2 verres/j)"]
  show_or_hide_hint_for_toxics($alcool_input, $alcool_input.val(), alcool_values)
  $alcool_input.on 'change', (event) -> show_or_hide_hint_for_toxics($(this), event.val, alcool_values)

  # calculateur dates
  $("#dossier_date_naissance").on 'blur', ->
    unless $("#dossier_age").val()
      date_naissance = parse_fr_date($(this).val())
      date_appel = parse_fr_date($("#dossier_date_appel").val())
      $("#dossier_age").val(getYears(date_naissance, date_appel))

  $(".calc_dates_grossesse").calculateGrossesse()
  $(".clear_date").resetDates()

  #### Evolution ####
  show_or_hide_issue_elements($("#dossier_evolution"), $("#dossier_evolution").val())
  $("#dossier_evolution").on 'change', (event) -> show_or_hide_issue_elements($(this), event.val)

  #### Correspondant ####
  $("#dossier_correspondant_id").attach_correspondant_select2()

  $new_correspondant_btn = $(".corr_create")
  $edit_correspondant_btn = $(".corr_update")

  # desactivate edit correspondant by default
  $edit_correspondant_btn.hide()

  # activate edit correspondant if dossier_correspondant_id is prefilled
  correspondant_id = $("#dossier_correspondant_id").val()
  activateCorrespondantEdit(correspondant_id) if correspondant_id

  $("#dossier_correspondant_id_field").remoteCorrespondantForm()

# functions & jQuery plugins

$.fn.attach_correspondant_select2 = () ->
  @select2
    minimumInputLength: 3
    width: "100%"
    initSelection : (element, callback) ->
      preload = element.data("load")
      callback(preload)
    ajax:
      url: @data("source")
      dataType: "json"
      data: (term, page) ->
        q: term
        page_limit: 10
      results: (data, page) ->
        return {results: data}
  @on "change", (e) =>
    if e.val then activateCorrespondantEdit(e.val) else $(".corr_update").hide()

  $('.select2-search-field input').css('width', '100%')

zero_grossesse_fields = ->
  fields = []
  fields.push($("#dossier_#{field_name}")) for field_name in ["fcs", "geu", "miu", "ivg", "img", "nai"]
  field.val("0") for field in fields

activateCorrespondantEdit = (correspondant_id) ->
  $edit_correspondant_btn = $(".corr_update")
  $edit_correspondant_btn.attr("href", "/correspondants/#{correspondant_id}/edit?modal=true")
  $edit_correspondant_btn.show()

$.widget "terappel.remoteCorrespondantForm",
  options:
    action: null

  _create: ->
    dom_widget = @element
    @element.find(".corr_create").unbind().bind "click", (e) =>
      @_bindModalOpening e, $(e.target).attr("href")

    @element.find(".corr_update").unbind().bind "click", (e) =>
      if (value = $("#dossier_correspondant_id").val())
        @_bindModalOpening e, $(e.target).attr("href").replace('__ID__', value)
      else
        e.preventDefault()

  _bindModalOpening: (e, url) ->
    e.preventDefault()
    dialog = @_getModal()

    setTimeout(=>
      $.ajax
        url: url
        beforeSend: (xhr) ->
          xhr.setRequestHeader "Accept", "text/javascript"
        success: (data, status, xhr) =>
          dialog.find(".modal-body").html(data)
          @_bindFormEvents()
        error: (xhr, status, error) ->
          dialog.find(".modal-body").html(xhr.responseText)
        dataType: "text"
      , 200)

  _bindFormEvents: ->
    dialog = @_getModal()
    form = dialog.find("form")
    saveButtonText = "Enregistrer"
    dialog.find('.form-actions').remove()

    form.attr("data-remote", true)
    dialog.find('#modal-label').text form.data('title')
    dialog.find(".save-action").unbind().click(->
      form.submit()
      return false
    ).html(saveButtonText)

    form.bind "ajax:complete", (e, xhr, status) =>
      if status is "error"
        dialog.find(".modal-body").html xhr.responseText
        @_bindFormEvents()
      else
        json = $.parseJSON xhr.responseText
        correspondant_label = json.label
        correspondant_id = json.id
        $edit_correspondant_btn = $(".corr_update")
        $edit_correspondant_btn.attr("href", "/correspondants/#{correspondant_id}/edit")
        $edit_correspondant_btn.show()
        @element.find("#dossier_correspondant_id").select2("data", {id: correspondant_id, text: correspondant_label})
        @_trigger("success")
        dialog.modal("hide")

  _getModal: ->
    unless @dialog
      @dialog = $('<div id="correspondant_modal" class="modal fade" role="dialog", aria-labelledby="modal-label" aria-hidden="true">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 id="modal-label">...<h3>
          </div>
          <div class="modal-body">
            ...
          </div>
          <div class="modal-footer">
            <a href="#" class="btn btn-primary save-action">...</a>
            <button class="btn" data-dismiss="modal" aria-hidden="true">Fermer</>
          </div>
        </div>')
        .modal(
          keyboard: true
          backdrop: true
          show: true
        ).on "hidden", =>
          @dialog.remove()
          @dialog = null
    return @dialog
