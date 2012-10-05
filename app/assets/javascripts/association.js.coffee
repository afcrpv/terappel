class @Association
  constructor: (name, attributes) ->
    @name = name
    @attributes = attributes

$.widget "terappel.validateAssociation"
  options:
    modelName: null
    modelId: null
    selectedFields: []

  _create: ->
    @_bindActions(@options.modelName, @options.selectedFields)

  pluralNameAndId: ->
    "#{@options.modelName}s_#{@options.modelId}"

  _bindActions: (model_name, selected_fields) ->
    $start_point = @element.closest(".nested-fields")
    @options.modelId = model_id = $start_point.find("input").filter(":first").attr("name").match(/[0-9]+/).join()
    plural_name_and_id = @pluralNameAndId()

    @element.on 'click', (e) =>
      e.preventDefault()

      association = new Association(model_name, @_getFieldsValues($start_point))
      values = for key, value of association.attributes
        value

      $target = $("##{model_name}s_summary")

      # don't do anything if collected attributes values are all empty
      if values.join("").length
        $model_row = @_getModelRow($target)
        @_actionsCell($model_row)
        @_fieldsCells($model_row, association.attributes)
        $start_point.hide()
      else
        @_emptyFieldsError()

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
    $('<p id="exposition_message">')
      .insertBefore(@element)
      .text("Vous devez remplir au moins un nom de produit")

  _getFieldsValues: ($start_point) ->
    fields_and_values = {}

    for field in $start_point.find("input, select")
      name = $(field).attr('name').replace(/\w+\[\w+\]\[\d+\]\[(\w+)\]/, '$1')
      fields_and_values[name] = $(field).val()

    selected_attributes = {}
    for field in @options.selectedFields
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
    $destroy_link = $("<a href='#association_destroy' id='destroy_#{plural_name_and_id}' class='destroy_link' data-toggle='modal' title='Détruire cette #{model_name}'><img alt='X' src='/assets/icons/destroy.png'></a>")

    $("#association_destroy").on 'click', '#confirm-destruction', (event) ->
      event.preventDefault()

      # remove the model row from the DOM
      $model_row.remove()
      # marks the corresponding model for destroy assigning the _destroy input value to 1
      $related_fieldset.find("input[type=hidden]").val("1")
      # and close the modal
      $(@).closest(".modal").modal('hide')

    return $destroy_link

  _modifyLink: (model_name, $related_fieldset) ->
    plural_name_and_id = @pluralNameAndId()
    $modify_link = $("<a href='#' id='modify_#{plural_name_and_id}' class='modify_link' title='Modifier cette #{model_name}'><img alt='M' src='/assets/icons/edit.png'></a>")
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
    $attach = $("#expositions")
    $attach.bind 'insertion-callback', ->
      hide_add_field_link("expositions")
      $(".nested-fields").filter(":visible").find(".combobox").combobox()
      $(".calendar").expo_termes_calc()
      $(".duree_calc").duree_expo_calc()
      disableSubmitWithEnter()
    $attach.bind 'removal-callback', -> show_add_field_link("expositions")

  # assign validate expo to related button
  $("form").on 'click', ".validate_expo", (event) ->
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
    validate_field(this, $start_point, $target, expo_values, "expositions")

  prefill_summary_table("expositions")

  #### BEBES ####
  for association in ["malformation", "pathologie"]
    do (association) ->

      # when clicking on #bebes tab link
      $("#tabs li a[href='#bebes']").bind 'click', ->

        $(".#{association}_tokens").attach_select2 association, "/#{association}s.json"
        prefill_summary_table("bebes")

        $("select[id$=#{association}]").check_show_association_tokens(association)

        $attach = $('#bebes')
        $attach.bind 'insertion-callback', ->
          hide_add_field_link("bebes")
          $(".#{association}_tokens").attach_select2 association, "/#{association}s.json"

          $("select[id$=_#{association}]").last().check_show_association_tokens(association)
          $("a.show_#{association}_tree:visible").complete_modal_for_association(association)
        .bind 'removal-callback', ->
          show_add_field_link("bebes")

  # assign validate bebe to related button
  $(".validate_bebe").live 'click', (event) ->
    $start_point = $(this).closest(".nested-fields")
    # collect sexe, poids, taille, pc, apgar1, apgar5, malformation, pathologie fields values
    bebe_values = [
      $start_point.find("select[id*='sexe']").val()
      $start_point.find("input[id$='_poids']").val()
      $start_point.find("input[id$='_taille']").val()
      $start_point.find("input[id$='_pc']").val()
      $start_point.find("input[id$='_apgar1']").val()
      $start_point.find("input[id$='_apgar5']").val()
      $start_point.find("select[name*='malformation'] option").filter(":selected").text()
      $start_point.find("select[name*='pathologie'] option").filter(":selected").text()
    ]
    $target = $("#bebes_summary tbody")
    validate_field(this, $start_point, $target, bebe_values, "bebes")

$.fn.attach_select2 = (association, url) ->
  @select2
    minimumInputLength: 3
    multiple: true
    initSelection : (element, callback) ->
      preload = element.data("load")
      callback(preload)
    width: "80%"
    ajax:
      url: url
      dataType: "json"
      data: (term, page) ->
        q: term
        page_limit: 10
      results: (data, page) ->
        return {results: data}
  @on "change", (e) =>
    $.ajax
      url: "/#{association}s/ancestors.json"
      dataType: 'json'
      data: {id: e.val[0]}
      success: (data) =>
        initial_ancestors = @data("initial-ancestors")
        @data("initial-ancestors", initial_ancestors.concat data)

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

    # ... or changes to oui
    $select.on "change", ->
      condition = $(this).val() is "Oui"
      next = $(this).nextAll(".#{association}_tokens")
      showNextif condition, $(this), next

validate_field = (button, $start_point, $target, values, model) ->
  $this = $(button)

  # also get the unique id of the model
  model_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

  # don't do anything if fields to copy are all blank
  if values.join("") isnt ""
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

  $modify_link = $("<a href='#' id='modify_#{model}_#{model_id}' class='modify_link' title='Modifier cette exposition'><img alt='M' src='/assets/icons/edit.png'></a>")
  $modify_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related model form
    $related_fieldset.slideToggle()

    hide_add_field_link(model)
    if model is "bebes"
      for association in ["malformation", "pathologie"]
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association)

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
