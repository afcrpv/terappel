# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  better_errors_list()

  $("#tabs li a[href='#bebes']").bind 'click', ->
    $attach = $('#bebes')
    $attach.bind 'insertion-callback', ->
      attach_jquery_tokeninput()

    $(".modify_link").bind 'click', ->
      attach_jquery_tokeninput() if $('.token-input-list-facebook').length == 0


  # bootstrap tabs
  $("#tabs").tabs()

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
    validate_field(event, this, $start_point, $target, expo_values)

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
    validate_field(event, this, $start_point, $target, bebe_values)

  # prefill summary tables for expos and bebes

  prefill_summary_table("expositions")
  prefill_summary_table("bebes")

# functions

attach_jquery_tokeninput = ->
  $("textarea[id*=malformation_tokens]").tokenInput("/malformations.json",
    propertyToSearch: "libelle"
    theme: "facebook"
    noResultsText: "Aucun résultat"
    searchingText: "Recherche en cours..."
    preventDuplicates: true
  )

validate_field = (event, button, $start_point, $target, values) ->
  $this = $(button)
  console.log(button)
  event.preventDefault() # prevent default event behavior
  # start point is the closest parent ol node of the link, it contains the fields to copy


  # also get the unique id of the expo
  expo_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()
  console.log(expo_id)
  console.log(values)

  # don't do anything if fields to copy are all blank
  if values.join("") isnt ""
    append_to_summary(values, $target, expo_id)
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

  expo_ids = (collect_field_id($(start_point)) for start_point in start_points)
  console.log("#{model} ids = #{expo_ids}")

  values_set = []
  #values_set.push collect_values_to_copy($(start_point)) for start_point in start_points
  for start_point in start_points
    values_set.push collect_values_to_copy($(start_point), model)

  console.log("Values collected = #{values_set}")
  append_to_summary(values, $target, expo_ids[i]) for values, i in values_set

collect_field_id = ($start_point) ->
  expo_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

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

append_to_summary = (fields, $target, expo_id) ->
  console.log($target)
  # check whether a row with id equal to collected expo id exists
  if $target.find("tr#expo_#{expo_id}").length isnt 0
    $expo_row = $target.find("tr#expo_#{expo_id}")
    $expo_row.empty()
  else
    $expo_row = $("<tr id='expo_#{expo_id}' />")
    # append the new row to the tbody
    $expo_row.appendTo($target)

  # create a cell with the action links
  cell_for_action_links($expo_row, expo_id)

  # create cells with collected fields
  create_cells $expo_row, field for field in fields

create_cells = ($node, text) ->
  $node.append("<td>#{text}</td>")

cell_for_action_links = ($node, expo_id) ->
  $cell = $("<td />")
  $related_fieldset = $node.parents().find(".nested-fields").has("div[id*='#{expo_id}']")

  $modify_link = $("<a href='#' id='modify_expo_#{expo_id}' class='modify_link'><img alt='M' src='/assets/icons/edit.png'></a>")
  $modify_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related expo form
    $related_fieldset.slideToggle()

  $destroy_link = $("<a href='#' id='destroy_expo_#{expo_id}'><img alt='X' src='/assets/icons/destroy.png'></a>")
  $destroy_link.bind 'click', (event) ->
    event.preventDefault()
    # clicking the link removes the parent tr from the DOM
    $node.remove()
    # and marks the corresponding expo for destroy assigning the _destroy input value to 1
    $related_fieldset.find("input[type=hidden]").val("1")

  $modify_link.appendTo($cell)
  $destroy_link.appendTo($cell)

  $cell.appendTo($node)
