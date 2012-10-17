class @Association
  constructor: (name, attributes, required_attributes) ->
    @name = name
    @attributes = attributes
    @required_attributes = required_attributes

$.widget "terappel.validateAssociation"
  options:
    modelName: null
    modelId: null
    selectedFields: []
    requiredFields: []

  _create: ->
    @_bindActions(@options.modelName, @options.selectedFields, @options.requiredFields)

  pluralNameAndId: ->
    "#{@options.modelName}s_#{@options.modelId}"

  _bindActions: (model_name, selected_fields) ->
    $start_point = @element.closest(".nested-fields")
    @options.modelId = model_id = $start_point.find("input[id]").filter(":first").attr("id").match(/[0-9]+/).join()
    plural_name_and_id = @pluralNameAndId()

    @element.on 'click', (e) =>
      e.preventDefault()

      association = new Association(model_name, @_getFieldsValues($start_point, @options.selectedFields), @_getFieldsValues($start_point, @options.requiredFields))
      required_fields_values = for key, value of association.required_attributes
        value

      $target = $("##{model_name}s_summary")

      if required_fields_values.join("").length
        $model_row = @_getModelRow($target)
        @_actionsCell($model_row)
        @_fieldsCells($model_row, association.attributes)
        $start_point.hide()
        show_add_field_link("#{model_name}s")
      else
        @_emptyFieldsError()
        # maybe use instead a confirm dialog to close start point anyway

  _getModelRow: ($target) ->
    plural_name_and_id = @pluralNameAndId()
    #check if we need to replace an existing or create a new row
    if ($model_row = $target.find("tbody tr##{plural_name_and_id}")).length
      $model_row.empty()
    else
      ($model_row = $("<tr id='#{plural_name_and_id}' />")).
        appendTo($target.find("tbody"))

    return $model_row

  _emptyFieldsError: ->
    $("p#exposition_message").remove()
    $('<p id="exposition_message">')
      .insertBefore(@element)
      .text("Vous devez remplir au moins un nom de produit")

  _getFieldsValues: ($start_point, selectedFields) ->
    fields_and_values = {}

    for field in $start_point.find("input[id], select[id]")
      name = $(field).attr('id').replace(/dossier_\w+?_\w+?_\d+?_(\w+)$/, '$1')
      fields_and_values[name] = $(field).val()

    selected_attributes = {}
    for field in selectedFields
      selected_attributes[field] = fields_and_values[field]

    return selected_attributes

  _actionsCell: ($model_row) ->
    plural_name_and_id = @pluralNameAndId()
    model_name = @options.modelName
    model_id = @options.modelId
    $cell = $("<td />")
    $related_fieldset = $model_row
      .parents()
      .find(".nested-fields")
      .has("input[id*='_#{model_name}s_attributes_#{model_id}']")

    @_modifyLink(model_name, $related_fieldset)
      .appendTo($cell)
    @_destroyLink(model_name, $related_fieldset, $model_row)
      .appendTo($cell)

    $cell.appendTo($model_row)

  _destroyLink: (model_name, $related_fieldset, $model_row) ->
    plural_name_and_id = @pluralNameAndId()
    destroy_title = "'Détruire #{model_name}'"
    $destroy_link = $("<a href='##{model_name}_destroy' id='destroy_#{plural_name_and_id}' data-toggle='modal' title=#{destroy_title}><i class='icon-trash'></i><span style='display:none;'>#{destroy_title}</span></a>")

    $modal = $("##{model_name}_destroy")
    $($modal).find(".modal-header h3").text("Destruction #{model_name}")
    $modal.on 'click', '#confirm-destruction', (event) ->
      event.preventDefault()

      # remove the model row from the DOM
      $model_row.remove()
      # marks the corresponding model for destroy assigning the _destroy input value to 1
      $related_fieldset.find("input[type=hidden]").val("1")
      # and close the modal
      $("##{model_name}_destroy").modal('hide')

    return $destroy_link

  _modifyLink: (model_name, $related_fieldset) ->
    plural_name_and_id = @pluralNameAndId()
    modify_title = "'Modifier #{model_name}'"
    $modify_link = $("<a href='#' id='modify_#{plural_name_and_id}' class='modify_link' title=#{modify_title}><i class='icon-pencil'></i><span style='display:none;'>#{modify_title}</span></a>")
    $modify_link.one 'click', (e) ->
      e.preventDefault()
      # toggle the div.nested-fields containing the related model form
      $related_fieldset.slideToggle()
      hide_add_field_link("#{model_name}s")

      if model_name is "bebes"
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association) for association in ["malformation", "pathologie"]

      return $modify_link

  _fieldsCells: ($model_row, fields_and_values) ->
    for key, value of fields_and_values
      cell = $("<td class=\"#{key}\">")
      cell.appendTo($model_row)
        .text(value)

jQuery ->
  $("#tabs li a[href='#expositions']").bind 'click', ->
    for association in ["produit", "indication"]
      $(".#{association}_autocomplete").attach_expositions_select2(association, "/dossiers/#{association}s.json")

    prefill_summary_table("expositions")
    $(".calendar").expo_termes_calc()
    $(".duree_calc").duree_expo_calc()
    $(".validate_expo").validate_exposition()

    $("#expositions").bind 'cocoon:after-insert', ->
      for association in ["produit", "indication"]
        $(".#{association}_autocomplete").attach_expositions_select2(association, "/dossiers/#{association}s.json")
      $(".validate_expo").last().validate_exposition()
      $(select).select2() for select in $(".combobox").filter(":visible")
      $(".calendar").expo_termes_calc()
      $(".duree_calc").duree_expo_calc()
      disableSubmitWithEnter()

  #### BEBES ####
  $("#tabs li a[href='#bebes']").bind 'click', ->

    for association in ["malformation", "pathologie"]
      $(".#{association}_tokens").attach_bebes_select2 association, "/#{association}s.json"
      $("select[id$=#{association}]").check_show_association_tokens(association)

    prefill_summary_table("bebes")
    $(".validate_bebe").validate_bebe()

    $('#bebes').bind 'cocoon:after-insert', ->
      for association in ["malformation", "pathologie"]
        $(".#{association}_tokens").attach_bebes_select2 association, "/#{association}s.json"
        $("select[id$=_#{association}]").last().check_show_association_tokens(association)
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association)
      $(".validate_bebe").last().validate_bebe()
      $(select).select2() for select in $(".combobox").filter(":visible")
      disableSubmitWithEnter()

$.fn.validate_bebe = ->
  @each ->
    $(this).on 'click', (event) =>
      $start_point = $(this).closest(".nested-fields")
      # collect sexe, poids, taille, pc, apgar1, apgar5, malformation, pathologie fields values
      bebe_values = collect_values_to_copy($start_point, "bebes")
      $target = $("#bebes_summary tbody")
      validate_field(this, $start_point, $target, bebe_values, "bebes")

$.fn.validate_exposition = ->
  @each ->
    $(this).on 'click', (event) =>
      $start_point = $(this).closest(".nested-fields")
      # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields values
      expo_values = collect_values_to_copy($start_point, "expositions")
      $target = $("#expositions_summary tbody")
      validate_field(this, $start_point, $target, expo_values, "expositions")

$.fn.attach_bebes_select2 = (association, url) ->
  @select2
    minimumInputLength: 3
    multiple: true
    initSelection : (element, callback) ->
      preload = element.data("load")
      callback(preload)
    width: "75%"
    ajax:
      url: url
      dataType: "json"
      data: (term, page) ->
        q: term
        page_limit: 10
      results: (data, page) ->
        return {results: data}
  @on "change", (e) ->
    $.ajax
      url: "/#{association}s/ancestors.json"
      dataType: 'json'
      data: {id: e.val[0]}
      success: (data) =>
        initial_ancestors = if (original_data = $(this).data("initial-ancestors")) then original_data else []
        $(this).data("initial-ancestors", initial_ancestors.concat data)

  $('.select2-search-field input').css('width', '100%')

$.fn.attach_expositions_select2 = (association, url) ->
  @select2
    minimumInputLength: 3
    width: "80%"
    initSelection : (element, callback) ->
      preload = element.data("load")
      callback(preload)
    ajax:
      url: url
      dataType: "json"
      data: (term, page) ->
        q: term
        page_limit: 10
      results: (data, page) ->
        return {results: data}
  @on "change", (e) ->
    $.ajax
      url: "/dossiers/#{association}s.json?#{association}_id=#{e.val}"
      dataType: "json"
      success: (data) =>
        $(this).data("load", data[0])

  $('.select2-search-field input').css('width', '100%')

show_add_field_link = (association) ->
  $("a.add_fields[data-associations=#{association}]").show()

hide_add_field_link = (association) ->
  $("a.add_fields[data-associations=#{association}]").hide()

humanizePluralizeFormat = (string) ->
  myToUpper = (match) ->
    match.toUpperCase()
  return string.replace(/^[a-z]{1}/, myToUpper) + "s"

$.fn.check_show_association_tokens = (association) ->
  @each ->
    $select = $(this)
    $tokens = $($select.nextAll(".#{association}_tokens"))
    # make tokens visible when association field is == "Oui"
    condition = $select.val() is "Oui"
    showNextif condition, $select, $tokens
    showNextif condition, $select, $select.nextAll(".btn")

    # ... or changes to oui
    $select.on "change", ->
      condition = $(this).val() is "Oui"
      next = $(this).nextAll(".#{association}_tokens")
      showNextif condition, $(this), next
      showNextif condition, $(this), $(this).nextAll(".btn")

validate_field = (button, $start_point, $target, values, model) ->
  $this = $(button)

  # also get the unique id of the model
  model_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

  append_to_summary(values, $target, model_id, model)
  # toggle visibility of closest parent div.nested-fields
  $start_point.slideToggle()
  show_add_field_link(model)

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
      if (produit = $start_point.find("input[id$='produit_id']").data("load")) then produit.text else ""
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      if (indication = $start_point.find("input[id$='indication_id']").data("load")) then indication.text else ""
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
    ]
  else
    values = [
      $start_point.find("select[id*='sexe']").val()
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
  paraphs = $($related_field.find("div.#{association}_tokens ul div"))
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

  singular_model = model.replace(/s$/, "")
  modify_title = "'Modifier #{singular_model}'"
  $modify_link = $("<a href='#' id='modify_#{model}_#{model_id}' class='modify_link' title=#{modify_title}><i class='icon-pencil'></i><span style='display:none;'>#{modify_title}</span></a>")
  $modify_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related model form
    $related_fieldset.slideToggle()

    if model is "bebes"
      for association in ["malformation", "pathologie"]
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association)

  destroy_title = "'Détruire #{singular_model}'"
  $destroy_link = $("<a href='#' id='destroy_#{model}_#{model_id}' title=#{destroy_title}><i class='icon-trash'></i><span style='display:none;'>#{destroy_title}</span></a>")
  $destroy_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link removes the parent tr from the DOM
    $node.remove()
    # and marks the corresponding model for destroy assigning the _destroy input value to 1
    $related_fieldset.find("input[id$=destroy]").val("1")

  $modify_link.appendTo($cell)
  $destroy_link.appendTo($cell)

  $cell.appendTo($node)

jQuery.fn.complete_modal_for_association = (association) ->
  @on 'click', =>
    field = @prevAll("input")
    bebe_id = field.attr("id").match(/[0-9]+/).join()
    association_modal_id = "#{association}_bebe_#{bebe_id}_modal"
    $modal = $(".modal##{association}")
    @attr("data-controls-modal", association_modal_id)
    $modal.attr("data-bebe-id", bebe_id)
    $modal.find(".#{association}s_container").html("")
    $(".#{association}s_tree").attach_jstree(association, bebe_id)

jQuery.fn.attach_jstree = (association, bebe_id) ->
  $select2_input = $("input#dossier_bebes_attributes_#{bebe_id}_#{association}_tokens")
  @jstree
    json_data:
      ajax:
        url: "/#{association}s/tree.json"
        data: (node) -> return {parent_id: if node.attr then node.attr("id") else 0}
    plugins: ["themes", "json_data", "ui", "checkbox"]
    core:
      initially_open: $select2_input.data("initial-ancestors")
    themes:
      theme: 'apple'
    checkbox:
      override_ui: true
      two_state: true
    ui:
      initially_select: $select2_input.val().split(",")
  .bind "loaded.jstree", (event, data) ->
    console.log "tree##{$(this).attr('class')} is loaded"
  .bind "check_node.jstree uncheck_node.jstree", ->
    # assign the following to check/uncheck node events
    nodes = $(this).jstree("get_checked")
    checked_nodes_objs = []
    checked_nodes_objs.push {id: $(node).attr("id"), text: $(node).attr("libelle")} for node in nodes
    html = []
    html.push "<ul>"
    for obj in checked_nodes_objs
      html.push "<li>#{obj.text}</li>"
    html.push "</ul>"
    # create a list with associations checked nodes
    $(this).parent().next().find(".#{association}s_container").html(html.join(""))
    $(this).parent().next().find("a").bind "click", (event) ->
      # assign action to add checked associations to be persisted in db
      event.preventDefault()
      $tokeninput = $(this).parents('body').find(".nested-fields:visible").find("input.#{association}_tokens")
      $modal = $(this).parents(".modal")
      $modal.modal('hide')
      $tokeninput.select2("data", checked_nodes_objs)
      # add parent nodes to initially open nodes
      for node in checked_nodes_objs
        $.ajax
          url: "/#{association}s/ancestors.json"
          dataType: 'json'
          data: {id: node.id}
          success: (data) ->
            initial_ancestors = $select2_input.data("initial-ancestors")
            $select2_input.data("initial-ancestors", initial_ancestors.concat data)
