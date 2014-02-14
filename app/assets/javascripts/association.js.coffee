$ = jQuery

$ ->
  ### EXPOSITIONS ###
  $("#tabs li a[href='#expositions']").bind 'click', ->
    for association in ["produit", "indication"]
      $(".#{association}_autocomplete").attach_expositions_select2(association, "/dossiers/#{association}s.json")

    $("table#expositions_summary").prefillSummaryTable
      modelName: "expositions"
    for expo_terme in ["periode_expo", "reprise_ttt"]
      $(".#{expo_terme}").expo_termes_calc($(".#{expo_terme} .#{prefix}_date"), $(".#{expo_terme} .#{prefix}")) for prefix in ["de", "a"]
      $(".#{expo_terme}").duree_expo()

    $(".validate_expo").validateAssociation
      modelName: "exposition"
      selectedFields: [
        "produit_id"
        "expo_terme_id"
        "indication_id"
        "dose"
        "de"
        "a"
        "de2"
        "a2"
      ]
      requiredFields: ["produit_id"]

    $("#expositions").bind 'cocoon:after-insert', ->
      for association in ["produit", "indication"]
        $(".#{association}_autocomplete").attach_expositions_select2(association, "/dossiers/#{association}s.json")
      $(".validate_expo").last().validateAssociation
        modelName: "exposition"
        selectedFields: [
          "produit_id"
          "expo_terme_id"
          "indication_id"
          "dose"
          "de"
          "a"
          "de2"
          "a2"
        ]
        requiredFields: ["produit_id"]

      $(select).select2() for select in $(".combobox").filter(":visible")

      for expo_terme in ["periode_expo", "reprise_ttt"]
        $(".#{expo_terme}").expo_termes_calc($(".#{expo_terme} .#{prefix}_date"), $(".#{expo_terme} .#{prefix}")) for prefix in ["de", "a"]
        $(".#{expo_terme}").duree_expo()

      disableSubmitWithEnter()

  #### BEBES ####
  $("#tabs li a[href='#bebes']").bind 'click', ->
    for association in ["malformation", "pathologie"]
      $(".#{association}_tokens").attach_bebes_select2 association, "/#{association}s.json"
      $("select[id$=#{association}]").check_show_association_tokens(association)

    $("table#bebes_summary").prefillSummaryTable
      modelName: "bebes"
    $(".validate_bebe").validateAssociation
      modelName: "bebe"
      selectedFields: [
        "sexe"
        "poids"
        "taille"
        "pc"
        "apgar1"
        "apgar5"
        "malformation"
        "pathologie"
      ]
      requiredFields: [
        "sexe"
      ]

    $('#bebes').bind 'cocoon:after-insert', ->
      for association in ["malformation", "pathologie"]
        $(".#{association}_tokens").attach_bebes_select2 association, "/#{association}s.json"
        $("select[id$=_#{association}]").last().check_show_association_tokens(association)
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association)
      $(".validate_bebe").last().validateAssociation
        modelName: "bebe"
        selectedFields: [
          "sexe"
          "poids"
          "taille"
          "pc"
          "apgar1"
          "apgar5"
          "malformation"
          "pathologie"
        ]
        requiredFields: [
          "sexe"
        ]

      $(select).select2() for select in $(".combobox").filter(":visible")
      disableSubmitWithEnter()

class @Association
  constructor: (name, attributes, required_attributes) ->
    @name = name
    @attributes = attributes
    @required_attributes = required_attributes

collectModelId = ($start_point) ->
  console.log $start_point.find("input[name]").filter(":first")
  $start_point.find("[name]").filter(":first").attr("name").match(/[0-9]+/).join()

destroyModal = (model_name, plural_name_and_id) ->
  $modal = $("""
    <div id="#{plural_name_and_id}_destroy" class="modal fade" role="dialog" aria-labelledby="destruction-label" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="destruction-label">Destruction #{model_name}</h4>
          </div>
          <div class="modal-body">
            <p>Cette opération est irreversible, veuillez confirmer.</p>
          </div>
          <div class="modal-footer">
            <a href="#" class="btn btn-danger" id="confirm-destruction-#{plural_name_and_id}">Confirmer</a>
            <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Annuler</button>
          </div>
        </div>
      </div>
    </div>
  """)

  return $modal

destroyLink = (model_name, $related_fieldset, $model_row, plural_name_and_id) ->
  destroy_title = "'Détruire #{model_name}'"
  $destroy_link = $("<a href='##{plural_name_and_id}_destroy' id='destroy_#{plural_name_and_id}' data-toggle='modal' title=#{destroy_title}><span class='glyphicon glyphicon-trash'></span><span style='display:none;'>#{destroy_title}</span></a>")

  destroyModal(model_name, plural_name_and_id)
    .appendTo("body")
  $("#confirm-destruction-#{plural_name_and_id}").bind 'click', (event) ->
    event.preventDefault()

    # remove the model row from the DOM
    target_row = $("tr##{plural_name_and_id}")
    target_row.remove()
    # check if target_row is an unsaved association
    if target_row.hasClass("live")
      $related_fieldset.remove()
    else
      # marks the corresponding model for destroy assigning the _destroy input value to 1
      $related_fieldset.find("input[type=hidden]").val("1")
    # and close the modal and destroy it
    $("##{plural_name_and_id}_destroy").modal('hide')

  return $destroy_link

modifyLink = (model_name, $related_fieldset, plural_name_and_id) ->
  modify_title = "'Modifier #{model_name}'"
  $modify_link = $("<a href='#' id='modify_#{plural_name_and_id}' class='modify_link' title=#{modify_title}><span class='glyphicon glyphicon-pencil'></span><span style='display:none;'>#{modify_title}</span></a>")
  $modify_link.one 'click', (e) ->
    e.preventDefault()
    # toggle the div.nested-fields containing the related model form
    $related_fieldset.slideToggle()
    hide_add_field_link("#{model_name}s")
    if model_name is "bebe"
      for association in ["malformation", "pathologie"]
        $("a.show_#{association}_tree:visible").complete_modal_for_association(association)

  return $modify_link

show_add_field_link = (association) -> $("a.add_fields[data-associations=#{association}]").show()

hide_add_field_link = (association) -> $("a.add_fields[data-associations=#{association}]").hide()

humanizePluralizeFormat = (string) ->
  myToUpper = (match) -> match.toUpperCase()
  return string.replace(/^[a-z]{1}/, myToUpper) + "s"

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

append_to_summary = (fields, $target, model_id, model, live=false) ->
  row_class = if live then "live" else ""
  # check whether a row with id equal to collected model id exists
  existing_row = $target.find("tr##{model}_#{model_id}")
  if $target.find("tr##{model}_#{model_id}").length isnt 0
    $model_row = $target.find("tr##{model}_#{model_id}")
    $model_row.empty()
  else # create a new row
    $model_row = $("<tr id='#{model}_#{model_id}' class='#{row_class}' />")
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
  plural_name_and_id = "#{model}_#{model_id}"
  $modify_link = modifyLink(singular_model, $related_fieldset, plural_name_and_id)
  $destroy_link = destroyLink(singular_model, $related_fieldset, $node, plural_name_and_id)

  $modify_link.appendTo($cell)
  $destroy_link.appendTo($cell)

  $cell.appendTo($node)

$.widget "terappel.prefillSummaryTable",
  options:
    modelName: null

  _create: ->
    $('.nested-fields').hide()
    $target = @element.find("tbody")

    start_points = $("##{@options.modelName} .nested-fields")

    model_ids = for start_point in start_points
      collectModelId($(start_point))

    values_set = for start_point in start_points
      collect_values_to_copy($(start_point), @options.modelName)

    for values, i in values_set
      append_to_summary(values, $target, model_ids[i], @options.modelName)

$.widget "terappel.validateAssociation",
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
    @options.modelId = model_id = collectModelId $($start_point)
    plural_name_and_id = @pluralNameAndId()

    @element.on 'click', (e) =>
      console.log "clicked validate action"
      e.preventDefault()

      association = new Association(model_name, @_getFieldsValues($start_point, @options.selectedFields), @_getFieldsValues($start_point, @options.requiredFields))
      required_fields_values = for key, value of association.required_attributes
        value

      $target = $("##{model_name}s_summary")

      console.dir association

      if required_fields_values.join("").length
        $model_row = @_getModelRow($target)
        @_actionsCell($model_row)
        @_fieldsCells($model_row, association.attributes)
        @_prepareMalfPathCells($model_row) if model_name is "bebe"
        $start_point.hide()
        show_add_field_link("#{model_name}s")
      else
        @_emptyFieldsError()

  _getModelRow: ($target) ->
    plural_name_and_id = @pluralNameAndId()
    #check if we need to replace an existing
    if ($model_row = $target.find("tbody tr##{plural_name_and_id}")).length
      $model_row.empty()
    else # or create a new row
      ($model_row = $("<tr id='#{plural_name_and_id}' class='live' />")).
        appendTo($target.find("tbody"))

    return $model_row

  _emptyFieldsError: ->
    required_field_list = @options.requiredFields.join(", ")
    model_name = @options.modelName
    $("##{model_name}_message").remove()
    $("<div id='#{model_name}_message' class='alert alert-danger'>")
      .insertBefore(@element)
      .text("Vous devez remplir : #{required_field_list}")

  _getFieldsValues: ($start_point, selectedFields) ->
    fields_and_values = {}

    for field in $start_point.find("input[id], select[id]")
      key = $(field).attr('id').replace(/dossier_\w+?_\w+?_\d+?_(\w+)$/, '$1')
      value = switch key
        when "produit_id", "indication_id"
          if (label = $(field).data("load")) then label.text else ""
        when "expo_terme_id", "malformation", "pathologie"
          $(field).find("option").filter(":selected").text()
        else $(field).val()

      fields_and_values[key] = value

    selected_attributes = {}
    for field in selectedFields
      selected_attributes[field] = fields_and_values[field]

    return selected_attributes

  _getRelatedFieldset: ($model_row) ->
    model_name = @options.modelName
    model_id = @options.modelId
    $model_row
      .parents()
      .find(".nested-fields")
      .has("input[id*='_#{model_name}s_attributes_#{model_id}']")

  _actionsCell: ($model_row) ->
    plural_name_and_id = @pluralNameAndId()
    model_name = @options.modelName
    $related_fieldset = @_getRelatedFieldset($model_row)

    $cell = $("<td />")
    modifyLink(model_name, $related_fieldset, plural_name_and_id)
      .appendTo($cell)
    destroyLink(model_name, $related_fieldset, $model_row, plural_name_and_id, true)
      .appendTo($cell)

    $cell.appendTo($model_row)

  _fieldsCells: ($model_row, fields_and_values) ->
    for key, value of fields_and_values
      cell_content = if value is "Oui" then "<a href='#' class='btn btn-danger' >#{value}</a>" else value
      $model_row.append("<td class=\"#{key}\">#{cell_content}</td")

  _prepareMalfPathCells: ($model_row) ->
    $related_fieldset = @_getRelatedFieldset($model_row)
    prepare_malf_and_path_columns($related_fieldset, $model_row, association) for association in ["malformation", "pathologie"]

$.fn.attach_bebes_select2 = (association, url) ->
  @select2
    minimumInputLength: 3
    multiple: true
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
    width: "100%"
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

$.fn.complete_modal_for_association = (association) ->
  @on 'click', =>
    field = @closest(".row").find("[name]").first()
    bebe_id = field.attr("id").match(/[0-9]+/).join()
    association_modal_id = "#{association}_bebe_#{bebe_id}_modal"
    $modal = $(".modal##{association}")
    @attr("data-controls-modal", association_modal_id)
    $modal.attr("data-bebe-id", bebe_id)
    $modal.find(".#{association}s_container").html("")
    $(".#{association}s_tree").attach_jstree(association, bebe_id)

$.fn.attach_jstree = (association, bebe_id) ->
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

class @SaExpo
  constructor: (dg_date, expo_date) ->
    parsed_dg_date = parse_fr_date(dg_date)
    @dg_date = parse_fr_date(addDays(parsed_dg_date, -14))
    @expo_date = parse_fr_date(expo_date)

  calculate: ->
    return "" if isNaN(@expo_date)
    return "Veuillez remplir la date de debut de grossesse !" if isNaN(@dg_date)
    result = getSA(@dg_date, @expo_date)
    return "La date d'exposition est antérieure à la date de debut de grossesse !" if result < 0
    result

class @DureeExpo
  constructor: (de, a) ->
    @de = parseInt(de)
    @a = parseInt(a)

  calculate: ->
    return "Veuillez remplir les champs 'de (SA)' et 'à (SA)' !" if @oneValueMissing()
    return "La valeur 'de (SA)' est > à 'à (SA)' !" if @a < @de
    @a - @de

  oneValueMissing: ->
    isNaN(@a) or isNaN(@de)

$.fn.expo_termes_calc = ($date, $sa) ->
  $base = $(this)

  $date.mask("99/99/9999")
  $date.blur ->
    ddg = $("#dossier_date_debut_grossesse").val()
    field.parents(".form-group").removeClass("has-error") for field in [$sa, $(@)]
    $sa.next("p.help-block").remove()
    result = new SaExpo(ddg, @value).calculate()
    if result.length? and result.length > 0
      field.parents(".form-group").addClass("has-error") for field in [$sa, $(@)]
      $sa.parents(".form-group").append("<p class='help-block'>#{result}</p>")
    else
      $sa.val(result)

$.fn.duree_expo = ->
  $base = $(this)
  $de = $base.find(".de")
  $base.find(".a").blur ->
    $duree = $base.find(".duree")
    field.parents(".form-group").removeClass("has-error") for field in [$de, $(this), $duree]
    $duree.next("p.help-block").remove()
    de = $de.val()
    a = $(this).val()
    result = new DureeExpo(de, a).calculate()
    if result.length?
      field.parents(".form-group").addClass("has-error") for field in [$de, $(this), $duree]
      $duree.parents(".form-group").append("<p class='help-block'>#{result}</p>")
    else
      $duree.val(result)
