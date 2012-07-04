# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#dossiers").dataTable
    oLanguage:
       #French translation
        #@name French
        #@anchor French
        #@author Guillaume LO RE

      "sProcessing":     "Traitement en cours..."
      "sLengthMenu":     "Afficher _MENU_ dossiers"
      "sZeroRecords":    "Aucun dossier &agrave; afficher"
      "sInfo":           "Affichage du dossier _START_ &agrave; _END_ sur _TOTAL_ dossiers"
      "sInfoEmpty":      "Affichage de dossier 0 &agrave; 0 sur 0 dossiers"
      "sInfoFiltered":   "(filtr&eacute; de _MAX_ dossiers au total)"
      "sInfoPostFix":    ""
      "sSearch":         "Nom patiente&nbsp;:"
      "sLoadingRecords": "Téléchargement..."
      "sUrl":            ""
      "oPaginate":
        "sFirst":    "Premi&egravere"
        "sPrevious": "Pr&eacute;c&eacute;dente"
        "sNext":     "Suivante"
        "sLast":     "Derni&egravere"
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#dossiers').data('source')
    aoColumnDefs: [
      { bSortable: false, aTargets: [4, 6, 7, 8]}
      { sWidth: "80px", aTargets: [ -1 ] }
      { sWidth: "150px", aTargets: [ 2, 4 ] }
    ]


  $("form.saisie").keypress (e) ->
    return false if e.which is 13

  calcIMC()
  better_errors_list()

  # jquery dialog for dossier details
  $dialog = $(".dialog")
  $(".dialog").dialog
    autoOpen: false
    modal: true
    width: 980

  $(".opener").on 'click', (event) ->
    event.preventDefault()
    dossier_id = $(this).attr("id")
    $dossier_dialog = $("#dossier_#{dossier_id}_modal")
    dossier_edit_url = $dossier_dialog.attr("data-edit")
    dossier_show_url = $dossier_dialog.attr("data-show")
    dialog_title = $dossier_dialog.attr("data-title")
    dialog_buttons = {}
    if $dossier_dialog.attr("data-edit")
      dialog_buttons["Modifier"] =
        text: "Modifier ce dossier"
        "class": "btn btn-info"
        click: -> window.location = dossier_edit_url
    if $dossier_dialog.attr("data-show")
      dialog_buttons["Voir"] =
        text: "Détails du dossier"
        "class": "btn btn-primary"
        click: -> window.location = dossier_show_url
    $dossier_dialog.dialog(
      buttons: dialog_buttons
      title: dialog_title)
      .dialog('open')

  # bootstrap form tabs
  $(".nav-tabs a:first").tab('show')
  $(".nav-pills a:first").tab('show')

  #### Validators and masks
  $.validator.setDefaults
    debug: false

  $("form.saisie").validate()

  $("#dossier_code").mask("aa9999999")
  $("#dossier_code").on "blur", ->
    value = $(this).val()
    $(this).val(value.toUpperCase())

  $("#dossier_age_grossesse").mask("?99")
  $("#dossier_terme").mask("?99")

  dates_grossesse_fields_names = ["date_appel", "date_dernieres_regles", "date_debut_grossesse", "date_accouchement_prevu", "date_reelle_accouchement", "date_naissance", "date_recueil_evol"]
  dates_grossesse_fields = []
  dates_grossesse_fields.push($("#dossier_#{field_name}")) for field_name in dates_grossesse_fields_names

  for date_field in dates_grossesse_fields
    date_field.mask("99/99/9999")
    value = date_field.attr("data-value")
    date_field.val(value) if value

  # calc imc
  $("#dossier_taille").on 'blur', -> calcIMC()

  for field in ["antecedents_perso", "antecedents_fam", "toxiques", "folique", "patho1t"]
    element = $("#dossier_#{field}")
    condition = element.val() is "0"
    showNextif condition, element
    element.on 'change', ->
      condition = $(this).val() is "0"
      showNextif condition, $(this)

  #### Grossesse
  $("#dossier_grsant").on 'blur', ->
    grsant = $(this).val()
    if grsant is "0" then zero_grossesse_fields()

  # reminder to fill expositions if tabac/alcool/toxiques equals "Oui"
  $tabac_element = $("#dossier_tabac")
  tabac = $tabac_element.val()
  showNextif tabac and tabac in ["1", "2", "3"], $tabac_element
  $tabac_element.on "change", ->
    tabac = $(this).val()
    showNextif tabac and tabac in ["1", "2", "3"], $(this)

  $alcool_element = $("#dossier_alcool")
  alcool = $alcool_element.val()
  showNextif alcool and alcool in ["1", "2"], $alcool_element
  $alcool_element.on "change", ->
    alcool = $(this).val()
    showNextif alcool and alcool in ["1", "2"], $(this)

  # calculateur dates
  $("#dossier_date_naissance").on 'blur', ->
    unless $("#dossier_age").val()
      date_naissance = parse_fr_date($(this).val())
      date_appel = parse_fr_date($("#dossier_date_appel").val())
      $("#dossier_age").val(getYears(date_naissance, date_appel))

  $("#calc_dates_grossesse").on 'click', -> calc_date_grossesse()
  $("#reset_dates_grossesse").on 'click', ->
    $("#grossesse_date_messages").html("")
    $('#dossier_age_grossesse').val("")
    $('#dossier_date_dernieres_regles').val("")
    $('#dossier_date_debut_grossesse').val("")
    $('#dossier_date_accouchement_prevu').val("")

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

  #### EXPOSITIONS ####
  $("#tabs li a[href='#expositions']").bind 'click', ->
    $attach = $("#expositions")
    $attach.bind 'insertion-callback', ->
      hide_add_field_link("expositions")
      $(".duree").on 'blur', ->
        de = $(this).prev().val()
        de2 = $(this).val()
        result = de2 - de
        $(this).nextAll("input").val(de2 - de) if result > 0

    $attach.bind 'removal-callback', ->
      show_add_field_link("expositions")

  # assign validate expo to related button
  $(".validate_expo").live 'click', (event) ->
    $start_point = $(this).closest(".nested-fields")
    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields values
    expo_values = [
      $start_point.find("input[id$='produit_name']").val()
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      $start_point.find("input[id$='indication_name']").val()
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
    ]
    $target = $("#expositions_summary tbody")
    validate_field(event, this, $start_point, $target, expo_values, "expositions")

  #### BEBES ####
  # prefill summary tables for expos and bebes
  prefill_summary_table("expositions")

  for association in ["malformation", "pathologie"]
    do (association) ->
      $(".#{association}s_tree").attach_jstree(association)

      # when clicking on #bebes tab link
      $("#tabs li a[href='#bebes']").bind 'click', ->
        $tokens = $("textarea.#{association}_tokens")
        $tokens.attach_jquery_tokeninput("/#{association}s.json")

        $("select[id$=#{association}]").check_show_association_tokens(association)

        prefill_summary_table("bebes")

        $attach = $('#bebes')
        $attach.bind 'insertion-callback', ->
          hide_add_field_link("bebes")

          # when the nested field is inserted check if the association trees buttons need to be shown
          $("select[id$=_#{association}]").last().check_show_association_tokens(association)

          # attach the jquery tokeninput to the bebe nested fields insertion callback
          $("textarea.#{association}_tokens").last().attach_jquery_tokeninput("/#{association}s.json")

          $(".#{association}s_tree").last().attach_jstree(association)
          $("a.show_#{association}_tree:visible").complete_modal_for_association(association)
        $attach.bind 'removal-callback', ->
          show_add_field_link("bebes")

  # assign validate bebe to related button
  $(".validate_bebe").live 'click', (event) ->
    $start_point = $(this).closest(".nested-fields")
    # collect sexe, poids, taille, pc, apgar1, apgar5, malformation, pathologie fields values
    bebe_values = [
      $start_point.find("input[id*='sexe']").filter(":checked").val()
      $start_point.find("input[id$='_poids']").val()
      $start_point.find("input[id$='_taille']").val()
      $start_point.find("input[id$='_pc']").val()
      $start_point.find("input[id$='_apgar1']").val()
      $start_point.find("input[id$='_apgar5']").val()
      $start_point.find("select[name*='malformation'] option").filter(":selected").text()
      $start_point.find("select[name*='pathologie'] option").filter(":selected").text()
    ]
    $target = $("#bebes_summary tbody")
    validate_field(event, this, $start_point, $target, bebe_values, "bebes")

# functions
calc_date_grossesse = ->
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

getYears = (startDate, endDate) ->
  unless isNaN(startDate.getTime()) and isNaN(endDate.getTime())
    start = startDate.getTime()
    end = endDate.getTime()
    delta = end - start
    days = delta / (1000 * 60 * 60 * 24)
    Math.round(days/365)

getSA = (dateDR, dateAppel) ->
  start = dateDR.getTime()
  end = dateAppel.getTime()
  delta = end - start
  days = delta / (1000 * 60 * 60 * 24)
  Math.round(days/7)

zero_grossesse_fields = ->
  fields_names = ["fcs", "geu", "miu", "ivg", "img", "nai"]
  fields = []
  fields.push($("#dossier_#{field_name}")) for field_name in fields_names
  field.val("0") for field in fields

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

parse_fr_date = (string) ->
  adata = string.split("/")
  gg = parseInt(adata[0],10)
  mm = parseInt(adata[1],10)
  aaaa = parseInt(adata[2],10)
  xdata = new Date(aaaa,mm-1,gg)

show_add_field_link = (association) ->
  $add_association_link = $("a.add_fields[data-associations=#{association}]")
  $add_association_link.show()

hide_add_field_link = (association) ->
  $add_association_link = $("a.add_fields[data-associations=#{association}]")
  $add_association_link.hide()

humanizePluralizeFormat = (string) ->
  myToUpper = (match) ->
    match.toUpperCase()
  return string.replace(/^[a-z]{1}/, myToUpper) + "s"

jQuery.fn.check_show_association_tokens = (association) ->
  tokens = this.closest("div.select").next(".#{association}_tokens")
  $tokens = $(tokens)
  $select = this

  # make tokens visible when association field is == "Oui"
  check_selected_option($select, $tokens)

  # ... or changes to oui
  this.change ->
    check_selected_option($(this), $tokens)

check_selected_option = ($select_elements, $tokens) ->
  selected_options = []
  selected_options.push $($select).find('option:selected').val() for $select in $select_elements

  # check if selected option is not empty
  for selected_option,i in selected_options
    $token = $($tokens[i])
    if selected_option
      check = if selected_option is "Oui" then true else false
    if check then $token.show() else $token.hide()

jQuery.fn.attach_jquery_tokeninput = (url) ->
  unless this.prev('.token-input-list-facebook').length
    this.tokenInput(url,
      propertyToSearch: "libelle"
      theme: "facebook"
      noResultsText: "Aucun résultat"
      searchingText: "Recherche en cours..."
      preventDuplicates: true
    )

validate_field = (event, button, $start_point, $target, values, model) ->
  $this = $(button)
  event.preventDefault() # prevent default event behavior

  # also get the unique id of the model
  model_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

  # don't do anything if fields to copy are all blank
  if values.join("") isnt ""
    append_to_summary(values, $target, model_id, model)
    # toggle visibility of closest parent div.nested-fields
    $start_point.slideToggle()
    show_add_field_link(model)

better_errors_list = ->
  $errors_container = $('ul.dossier_errors')
  $errors_header = $("<p><strong>#{$errors_container.attr('data-model_name')} invalide</strong><br />Veuillez vérifier les champs suivant (clicker sur les lignes pour modifier les champs invalides) :</p>")
  $errors_wrap = $('<div class="alert-message block-message error fade in" data-alert="alert" />')
  $errors_container.wrap($errors_wrap)
  $errors_header.prependTo($('.block-message'))

  # create a link for each li of ul.dossier_errors
  error_items = $errors_container.find('li')
  assign_select_tab($(error_item)) for error_item in error_items

assign_select_tab = (element) ->
  $tabs = $('#tabs').tabs()
  $element = $(element)
  error_text = $element.text()
  field_name = error_text.replace(" doit être rempli(e)", "")
  tab = if field_name.match(/patiente/)? then 1 else 0 # 0 = #infos, 1 = #patiente, 2 = #expositions
  $element.contents().wrap("<a href='#' />")
  # clicking on single errors switches to related tab
  $element.find('a').click ->
    $tabs.tabs('select', tab)
    # create a regexp using the current field_name and ignoring case
    exp = new RegExp("#{field_name}", "i")
    # find label having text attribute matching field_name ignoring case and then focus related input
    $input = $("label").filter( ->
      return ($(this).text().match(exp))).next('div').find('input')
    # focus the found input
    $input.focus()
    return false

prefill_summary_table = (model) ->
  $target = $("##{model} tbody")
  $('.nested-fields').hide()

  start_points = $("##{model} .nested-fields")

  model_ids = []
  model_ids.push(collect_field_id($(start_point))) for start_point in start_points

  values_set = []
  for start_point in start_points
    values_set.push collect_values_to_copy($(start_point), model)

  append_to_summary(values, $target, model_ids[i], model) for values, i in values_set

collect_field_id = ($start_point) ->
  $field = $start_point.find("select").filter(":first")
  field_id = $field.attr("name").match(/[0-9]+/).join()

collect_values_to_copy = ($start_point, model) ->
  # damn ugly... but i'm outta ideas for now, need a bit of oo to not do like this
  if model == "expositions"
    values = [
      $start_point.find("input[id$='produit_name']").val()
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      $start_point.find("input[id$='indication_name']").val()
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
    ]
  else
    values = [
      $start_point.find("input[id*='sexe']").filter(":checked").val()
      $start_point.find("input[id$='_poids']").val()
      $start_point.find("input[id$='_taille']").val()
      $start_point.find("input[id$='_pc']").val()
      $start_point.find("input[id$='_apgar1']").val()
      $start_point.find("input[id$='_apgar5']").val()
      $start_point.find("select[name*='malformation'] option").filter(":selected").text()
      $start_point.find("select[name*='pathologie'] option").filter(":selected").text()
    ]
  return values

append_to_summary = (fields, $target, model_id, model) ->
  # check whether a row with id equal to collected model id exists
  if $target.find("tr##{model}_#{model_id}").length isnt 0
    $model_row = $target.find("tr##{model}_#{model_id}")
    $model_row.empty()
  else
    $model_row = $("<tr id='#{model}_#{model_id}' />")
    # append the new row to the tbody
    $model_row.appendTo($target)

  # create a cell with the action links
  cell_for_action_links($model_row, model_id, model)

  # create cells with collected fields
  create_cells $model_row, field for field in fields

  $related_field = $model_row.parents().find(".nested-fields").has("input[id*='_#{model}_attributes_#{model_id}']")

  if model is "bebes"
    for association in ["malformation", "pathologie"]
      prepare_malf_and_path_columns $related_field, $model_row, association

create_cells = ($node, text) ->
  if text is "Oui"
    cell_content = "<a href='#' class='btn btn-danger' >#{text}</a>"
  else
    cell_content = text

  $node.append("<td>#{cell_content}</td>")

prepare_malf_and_path_columns = ($related_field, $model_row, association) ->
  td_position = if association is "malformation" then 2 else 1

  #gather paraphs using $related_field
  paraphs = $related_field.find("div.#{association}_tokens ul p")

  # create a ul parent element
  html = "<ul>"
  # iterate the paraphs array and create html li from each text property
  html += "<li>#{$(p).text()}</li>" for p in paraphs
  html += "</ul>"

  link = $model_row.find("td:nth-last-child(#{td_position}) a")

  $(link).attr('data-original-title', humanizePluralizeFormat(association))
  # assign collected association names to data-content link attribute
  $(link).attr('data-content', html)
  $(link).popover(placement: 'left', html: true)
  $(link).bind 'click', (e) ->
    e.preventDefault()

cell_for_action_links = ($node, model_id, model) ->
  $cell = $("<td />")
  $related_fieldset = $node.parents().find(".nested-fields").has("input[id*='_#{model}_attributes_#{model_id}']")

  $modify_link = $("<a href='#' id='modify_#{model}_#{model_id}' class='modify_link' title='Modifier cette exposition'><img alt='M' src='/assets/icons/edit.png'></a>")
  $modify_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related model form
    $related_fieldset.slideToggle()

    hide_add_field_link(model)
    if model is "bebes"
      for association in ["malformation", "pathologie"]
        $link = $("a.show_#{association}_tree:visible")
        $link.complete_modal_for_association(association)

  $destroy_link = $("<a href='#' id='destroy_#{model}_#{model_id}' title='Détruire cette exposition'><img alt='X' src='/assets/icons/destroy.png'></a>")
  $destroy_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link removes the parent tr from the DOM
    $node.remove()
    # and marks the corresponding model for destroy assigning the _destroy input value to 1
    $related_fieldset.find("input[type=hidden]").val("1")

  $modify_link.appendTo($cell)
  $destroy_link.appendTo($cell)

  $cell.appendTo($node)

jQuery.fn.complete_modal_for_association = (association) ->
  field = this.prevAll("input")
  bebe_id = field.attr("id").match(/[0-9]+/).join()
  association_modal_id = "#{association}_bebe_#{bebe_id}_modal"
  $modal = this.parent().nextAll(".modal.#{association}")
  this.attr("data-controls-modal", association_modal_id)
  $modal.attr("id", association_modal_id)

jQuery.fn.attach_jstree = (association) ->
  this.bind "loaded.jstree", (event, data) ->
    console.log "tree##{$(this).attr('class')} is loaded"
  .jstree(
    "json_data" :
      "ajax" :
        "url" : "/#{association}s/tree.json"
        "data" : (node) ->
          return { parent_id : if node.attr then node.attr("id") else 0}
    plugins: ["themes", "json_data", "ui", "checkbox"]
    themes:
      theme: 'apple'
    checkbox:
      override_ui: true
      two_state: true
  )
  .bind "check_node.jstree uncheck_node.jstree", (event, data) ->
    # assign the following to check/uncheck node events
    nodes = $(this).jstree("get_checked")
    checked_nodes_objs = []
    checked_nodes_objs.push {id: $(node).attr("id"), libelle: $(node).attr("libelle")} for node in nodes
    names = []
    names.push(obj.libelle) for obj in checked_nodes_objs
    html = []
    html.push "<ul>"
    html.push "<li>#{name}</li>" for name in names
    html.push "</ul>"
    # create a list with associations checked nodes
    $(this).parent().next().find(".#{association}s_container").html(html.join(""))
    $(this).parent().next().find("a").bind "click", (event) ->
      # assign action to add checked associations to be persisted in db
      event.preventDefault()
      $tokeninput = $(this).parents('body').find(".nested-fields:visible").find("textarea[id$=#{association}_tokens]")
      $modal = $(this).parents(".modal")
      $modal.modal('hide')
      $tokeninput.tokenInput("add", obj) for obj in checked_nodes_objs

calcIMC = ->
  poids = $("#dossier_poids").val()
  taille = $("#dossier_taille").val()
  imc = if poids and taille then Math.round(poids / (Math.pow(taille/100, 2))) else ""
  $("#imc").html(imc)

showNextif = (condition, element) ->
  next = element.next()
  if condition then next.show() else next.hide()

activateCorrespondantEdit = (correspondant_id) ->
  $edit_correspondant_btn = $(".update")
  $edit_correspondant_btn.show()
  $edit_correspondant_btn.attr("data-link", "/correspondants/#{correspondant_id}/edit")
  $("#correspondant_modal_title").html("Modification correspondant #{correspondant_id}")
  $("#save-correspondant").html("Mettre à jour ce correspondant et assigner au dossier")
