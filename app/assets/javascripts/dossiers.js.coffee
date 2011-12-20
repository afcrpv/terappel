# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  better_errors_list()

  # bootstrap tabs
  $("#tabs").tabs()

  $malformation_tokens_inputs = $("textarea[id*=malformation_tokens]")
  attach_jquery_tokeninput($malformation_tokens_inputs, "malformation")

  check_show_malformation_tokens()

  # when clicking on #bebes tab link
  $("#tabs li a[href='#bebes']").bind 'click', ->
    $attach = $('#bebes')
    # attach the jquery tokeninput to the bebe nested fields insertion callback
    $attach.bind 'insertion-callback', ->
      attach_jquery_tokeninput($malformation_tokens_inputs.last(), "malformation")
      check_show_malformation_tokens()

    #$(".modify_link").bind 'click', ->
      #check_show_malformation_tokens()

  # assign validate expo to related button
  $(".validate_expo").live 'click', (event) ->
    $start_point = $(this).closest(".nested-fields")
    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields values
    expo_values = [
      $start_point.find("select[name*='produit'] option").filter(":selected").text()
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      $start_point.find("select[name*='indication'] option").filter(":selected").text()
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
    ]
    $target = $("#expositions_summary tbody")
    validate_field(event, this, $start_point, $target, expo_values, "expositions")

  # assign validate bebe to related button
  $(".validate_bebe").live 'click', (event) ->
    $start_point = $(this).closest(".nested-fields")
    # collect sexe, poids, taille, pc, apgar1, apgar5, malforma, patho fields values
    bebe_values = [
      $start_point.find("select[name*='sexe'] option").filter(":selected").text()
      $start_point.find("input[id$='_poids']").val()
      $start_point.find("input[id$='_taille']").val()
      $start_point.find("input[id$='_pc']").val()
      $start_point.find("input[id$='_apgar1']").val()
      $start_point.find("input[id$='_apgar5']").val()
      $start_point.find("select[name*='malforma'] option").filter(":selected").text()
      $start_point.find("select[name*='patho'] option").filter(":selected").text()
    ]
    $target = $("#bebes_summary tbody")
    validate_field(event, this, $start_point, $target, bebe_values, "bebes")

  # prefill summary tables for expos and bebes
  prefill_summary_table("expositions")
  prefill_summary_table("bebes")

  prepare_malf_and_path_columns $('table#bebes_summary'), "malformation"

# functions

humanizePluralizeFormat = (string) ->
  myToUpper = (match) ->
    match.toUpperCase()
  return string.replace(/^[a-z]{1}/, myToUpper) + "s"

prepare_malf_and_path_columns = (table, association) ->
  # placeholder for collected malformations names
  test_malfs = '<ul><li>mal1</li><li>mal2</li></ul>'

  rows = table.find('tr[id]')

  bebe_ids = []
  bebe_ids.push $(row).attr('id').match(/[0-9]+/) for row in rows

  # gather token input ul elements
  association_lists = $("#bebes .nested-fields .#{association}_tokens ul")
  console.log association_lists

  association_lists_items = []
  for association_list, i in association_lists
    association_lists_items[i] = $(association_list).html()#('li[class=token-input-token-facebook]').html()]

  new_lists = []
  for list in association_lists_items
    new_lists.push list.match(/<p>\w+<\/p>/g)
  console.log new_lists

  links = table.find('td:nth-last-child(2) a')

  for link, i in links
    $(link).attr('data-original-title', humanizePluralizeFormat(association))
    # assign collected association names to data-content link attribute
    $(link).attr('data-content', new_lists[i].toString().replace(',', ''))
    $(link).popover(placement: 'above', html: true)
    $(link).bind 'click', (e) ->
      e.preventDefault()

check_show_malformation_tokens = ->
  $malformation_select = $('select[id$=_malforma]')
  # make malformation_tokens div visible when malformation field is == "oui"
  show_malformation_tokens($malformation_select)
  # ... or changes to oui
  $malformation_select.change ->
    $this = $(this)
    show_malformation_tokens($this)

show_malformation_tokens = ($el) ->
  $this = $el
  malf = $this.find('option:selected').val()
  $malformation_tokens = $this.closest('.select').next('.malformation_tokens')
  if malf is "Oui"
    $malformation_tokens.show()
  else
    $malformation_tokens.hide()


attach_jquery_tokeninput = ($target, association) ->
  $target.tokenInput("/#{association}s.json",
    propertyToSearch: "libelle"
    theme: "facebook"
    noResultsText: "Aucun résultat"
    searchingText: "Recherche en cours..."
    preventDuplicates: true
  ) if $target.prev('ul').length == 0

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

  # hide nested fields for expositions and bebes
  $("#tabs li a[href='##{model}']").bind 'click', ->
    $('.nested-fields').hide()

  start_points = $("##{model} .nested-fields")

  model_ids = (collect_field_id($(start_point)) for start_point in start_points)

  values_set = []
  for start_point in start_points
    values_set.push collect_values_to_copy($(start_point), model)

  append_to_summary(values, $target, model_ids[i], model) for values, i in values_set

collect_field_id = ($start_point) ->
  field_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

collect_values_to_copy = ($start_point, model) ->
  # damn ugly... but i'm outta ideas for now, need a bit of oo to not do like this
  if model == "expositions"
    values = [
      $start_point.find("select[name*='produit'] option").filter(":selected").text()
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      $start_point.find("select[name*='indication'] option").filter(":selected").text()
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
    ]
  else
    values = [
      $start_point.find("select[name*='sexe'] option").filter(":selected").text()
      $start_point.find("input[id$='_poids']").val()
      $start_point.find("input[id$='_taille']").val()
      $start_point.find("input[id$='_pc']").val()
      $start_point.find("input[id$='_apgar1']").val()
      $start_point.find("input[id$='_apgar5']").val()
      $start_point.find("select[name*='malforma'] option").filter(":selected").text()
      $start_point.find("select[name*='patho'] option").filter(":selected").text()
    ]
  return values

append_to_summary = (fields, $target, model_id, model) ->
  # check whether a row with id equal to collected model id exists
  if $target.find("tr##{model}_#{model_id}").length isnt 0
    $model_row = $target.find("tr##{model}_#{model_id}")
    $model_row.empty()
  else
    # create a new row and append it to the tbody
    $model_row = $("<tr id='#{model}_#{model_id}' />")
    $model_row.appendTo($target)

  # create a cell with the action links
  cell_for_action_links($model_row, model_id, model)

  # create cells with collected fields
  create_cells $model_row, field for field in fields

create_cells = ($node, text) ->
  cell_content = if text is "Oui" then "<a href='#' class='btn danger'>#{text}</a>" else text
  $node.append("<td>#{cell_content}</td>")

cell_for_action_links = ($node, model_id, model) ->
  $cell = $("<td />")
  $related_fieldset = $node.parents().find(".nested-fields").has("div[id*='#{model}_attributes_#{model_id}']")

  $modify_link = $("<a href='#' id='modify_#{model}_#{model_id}' class='modify_link'><img alt='M' src='/assets/icons/edit.png'></a>")
  $modify_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related model form
    $related_fieldset.slideToggle()

  $destroy_link = $("<a href='#' id='destroy_#{model}_#{model_id}'><img alt='X' src='/assets/icons/destroy.png'></a>")
  $destroy_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link removes the parent tr from the DOM
    $node.remove()
    # and marks the corresponding model for destroy assigning the _destroy input value to 1
    $related_fieldset.find("input[type=hidden]").val("1")

  $modify_link.appendTo($cell)
  $destroy_link.appendTo($cell)

  $cell.appendTo($node)
