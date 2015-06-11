$ = jQuery

$ ->
  $('body').on 'hidden.bs.modal', '#dossier_modal', -> $(@).removeData('modal')

  $("[data-field=dossier_expositions]").on "click", (e) ->
    e.preventDefault()
    $("#tabs a[href='#expositions']").tab("show")

  $('body').on 'click', '.show-dossier-modal', (ev) ->
    ev.preventDefault()
    modal_id = $(@).attr('data-target')
    code = $(@).data('dossierCode')
    base_url = $(@).data('baseUrl')
    dossierPreview(modal_id, code, base_url)

  disableSubmitWithEnter()

  # show dossier preview if params[:dossier][:show_preview] == "true"
  dossierPreview("#dossier_modal",
    (dossier_code = $("#dossier_code").val()),
    "/dossiers/#{dossier_code}",
    false) if $("input#dossier_show_preview").val() is "true"

  # bootstrap form tabs
  current_tab = $("input#dossier_current_tab").val()
  $("#tabs a[href='##{current_tab}']").tab('show')

  $("[data-toggle=pill]").on "click", (e) ->
    href = "clicked #{@.href}"
    $("input#dossier_current_tab").val(href.split("#")[1])

  for field in ["code", "name"]
    $("#dossier_#{field}").on "blur", ->
      value = $(this).val()
      $(this).val(value.toUpperCase())

  $("#dossier_code").mask("aa9999999")

  grs_field_names = [
    "appel", "dernieres_regles", "debut_grossesse", "accouchement_prevu",
    "reelle_accouchement", "naissance", "recueil_evol"
  ]
  dates_grossesse_fields = []
  dates_grossesse_fields
    .push($("#dossier_date_#{field_name}")) for field_name in grs_field_names

  for date_field in dates_grossesse_fields
    date_field.mask("99/99/9999")
    value = date_field.attr("data-value")
    date_field.val(value) if value

  # calc imc
  $("#dossier_#{field}")
    .calculateBMI("#dossier_imc") for field in ["taille", "poids"]

  #### Grossesse
  $("#dossier_grsant").zeroGrossesseFields()
  $(".grsant_coherence").checkGrsantCoherence()

  for field in ["toxiques", "folique", "patho1t"]
    element = $("#dossier_#{field}")
    condition = element.val() is "Oui"
    next = element.parent().find(".help-block")
    showNextif condition, element, next
    element.on 'change', ->
      condition = $(this).val() is "Oui"
      next = $(this).parent().find(".help-block")
      showNextif condition, $(this), next

  for field in ["antecedents_perso", "antecedents_fam"]
    element = $("#dossier_#{field}")
    condition = element.val() is "Oui"
    next = element.closest(".row").find(".comm_atcds")
    showNextif condition, element, next
    element.on 'change', ->
      condition = $(this).val() is "Oui"
      next = $(this).closest(".row").find(".comm_atcds")
      showNextif condition, $(this), next

  # calculateur dates
  $("#dossier_date_naissance").on 'blur', ->
    unless $("#dossier_age").val()
      date_naissance = parse_fr_date($(this).val())
      date_appel = parse_fr_date($("#dossier_date_appel").val())
      $("#dossier_age").val(getYears(date_naissance, date_appel))

  $(".calc_dates_grossesse").calculateGrossesse()
  $(".clear_date").resetDates()

  $("#dossier_date_reelle_accouchement").calculateTermeNaissance()

  #### Evolution ####

  $("#dossier_evolution").show_or_hide_issue_elements()

  #### Correspondant ####
  for name in ["demandeur", "relance"]
    $("#dossier_#{name}_attributes_correspondant_id")
      .attach_correspondant_select2(name)
    $("#dossier_#{name}_id_field")
      .remoteCorrespondantForm({typeCorrespondant: name})
    correspondant_id = $("#dossier_#{name}_attributes_correspondant_id").val()
    activateCorrespondantEdit(correspondant_id, name)

  # relance
  showNextif ($("#dossier_relance_attributes_correspondant_id").val() isnt ""),
    $("#dossier_relance_attributes_correspondant_id"),
    $("#dossier_relance_id_field")

  $("#dossier_a_relancer").on "change", ->
    $("#relance").modal("show") if @value is "Oui"

  $('body').on 'hidden.bs.modal', '#relance', ->
    $("#dossier_relance_id_field").show()

  $(".copy-correspondant").on "click", ->
    if (demandeur = $("#dossier_demandeur_attributes_correspondant_id").val())
      $relance = $("#dossier_relance_attributes_correspondant_id")
      $relance.val(demandeur).trigger('change')
      activateCorrespondantEdit(demandeur, "relance")

# functions & jQuery plugins
dossierPreview = (modal_id, code, base_url, edit = true) ->
  $(modal_id + " .code").html(code)
  if edit
    $(modal_id + " .edit-dossier").attr("href", "#{base_url}/edit")
  else
    $(modal_id + " .edit-dossier").remove()
  $(modal_id + " .print-dossier").attr("href", "#{base_url}.pdf")
  $(modal_id + " .modal-body").load base_url, -> $(modal_id).modal('show')

class @Parite
  constructor: (total, atcds) ->
    @total = parseInt(total)
    @atcds =
      parseInt(item) for item in atcds

  coherence: ->
    return true if @total is @atcds.reduce (x, y) -> x + y
    false

$.fn.checkGrsantCoherence = ->
  array = @
  @each ->
    $(this).blur ->
      can_fire = true
      empty_elements = []
      for element in array
        unless element.value
          can_fire = false
          empty_elements.push element

      $("#dossier_grsant").next(".help-block").remove()
      $message = $('<p class="help-block" />')
      field_names = ["fcs", "geu", "miu", "ivg", "img", "nai"]
      if can_fire is true
        total = $("#dossier_grsant").val()
        atcds =
          $("#dossier_#{field}").val() for field in field_names
        parite = new Parite(total, atcds)

        if parite.coherence()
          $message.html("Saisie correcte.")
          message_class = "has-success"
        else
          $message.html("Saisie incorrecte, vérifiez la somme !")
          message_class = "has-error"

        $(element).closest(".form-group")
          .attr("class", "form-group #{message_class}") for element in array
      else
        $message.html("Saisie incomplète, veuillez saisir tous les champs !")
        message_class = "has-warning"
        $(element).closest(".form-group")
          .attr("class",
            "form-group #{message_class}") for element in empty_elements
        $(this).closest(".form-group")
          .attr("class", "form-group has-success") if $(this).val()

      $("#dossier_grsant").closest(".form-group").append($message)

$.fn.zeroGrossesseFields = ->
  field_names = ["fcs", "geu", "miu", "ivg", "img", "nai"]
  @on 'blur', ->
    $("#dossier_#{field}")
      .val("0") for field in field_names if $(this).val() is "0"
    #think about skipping tabulations for all these zeroed fields

$.fn.attach_correspondant_select2 = (name) ->
  @select2
    minimumInputLength: 3
    ajax:
      dataType: "json"
      data: (params) ->
        q: params.term
        page_limit: params.page
      processResults: (data, page) ->
        return { results: data }
  @on "change", (e) ->
    if e.target.value
      activateCorrespondantEdit(e.target.value, name)
    else
      $("#dossier_#{name}_id_field .corr_update").hide()

activateCorrespondantEdit = (correspondant_id, name) ->
  $edit_correspondant_btn = $("#dossier_#{name}_id_field .corr_update")
  $edit_correspondant_btn
    .attr("href", "/correspondants/#{correspondant_id}/edit?modal=true")
  if correspondant_id
    $edit_correspondant_btn.show()
  else
    $edit_correspondant_btn.hide()

$.widget "terappel.remoteCorrespondantForm",
  options:
    typeCorrespondant: null

  _create: ->
    dom_widget = @element
    @element.find(".corr_create").unbind().bind "click", (e) =>
      @_bindModalOpening e, $(e.target).attr("href")

    @element.find(".corr_update").unbind().bind "click", (e) =>
      value = $("#dossier_#{@options["typeCorrespondant"]}" +
        "_attributes_correspondant_id").val()
      if value
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
        $edit_correspondant_btn = $("#dossier_#{@options["typeCorrespondant"]}
          _id_field .corr_update")
        $edit_correspondant_btn.attr("href",
          "/correspondants/#{correspondant_id}/edit")
        $edit_correspondant_btn.show()
        $select = @element.find("#dossier_#{@options["typeCorrespondant"]}
          _attributes_correspondant_id")
        $select.select2("data",
          {id: correspondant_id, text: correspondant_label})
        @_trigger("success")
        dialog.modal("hide")

  _getModal: ->
    unless @dialog
      @dialog = $('<div id="correspondant_modal" class="modal fade"
      role="dialog" aria-labelledby="modal-label" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modal-label">...<h3>
              </div>
              <div class="modal-body">
                ...
              </div>
              <div class="modal-footer">
                <a href="#" class="btn btn-primary save-action">...</a>
                <button class="btn btn-default" data-dismiss="modal"
                aria-hidden="true">Fermer</button>
              </div>
            </div>
          </div>
        </div>')
      .modal({keyboard: true, backdrop: true, show: true})
      .on "hidden.bs.modal", ->
        @dialog.remove()
        @dialog = null
    return @dialog

$.fn.show_or_hide_issue_elements = ->
  show_or_hide_issue @, @val()
  @on "change", (e) ->
    show_or_hide_issue e.target, e.target.value

show_or_hide_issue = (evolution_element, evolution_value) ->
  $hint = $(evolution_element).next(".help-block")
  if evolution_value and evolution_value in ["FCS", "IVG", "IMG", "MIU", "NAI"]
    $(".issue").show()
  else
    $(".issue").hide()

  if evolution_value is "NAI"
    # hide the hint inviting to add the malformation and the #date_recueil_evol
    # div and show the #modaccouch and #date_reelle_accouchement divs
    $hint.hide()
    $("#date_recueil_evol").hide()
    for field in ["modaccouch", "date_reelle_accouchement"]
      $("##{field}").show()
  else if evolution_value in ["FCS", "IVG", "IMG", "MIU"]
    # show the #date_recueil_evol div and the hint inviting to add the
    # malformation
    $hint.show()
    $("#date_recueil_evol").show()
    for field in ["modaccouch", "date_reelle_accouchement"]
      $("##{field}").hide()
  else
    $hint.hide()
