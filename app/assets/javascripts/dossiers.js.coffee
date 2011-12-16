# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  better_errors_list()

  # bootstrap tabs
  $("#tabs").tabs()
  $(".validate_expo").live 'click', (event) ->
    $this = $(this)
    event.preventDefault() # prevent default event behavior
    # start point is the closest parent ol node of the link, it contains the fields to copy
    $start_point = $this.closest(".nested-fields")

    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields
    values_to_copy = collect_values_to_copy($start_point)

    # also get the unique id of the expo
    expo_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

    # don't do anything if fields to copy are all blank
    if values_to_copy.join("") isnt ""
      append_to_expo_summary(values_to_copy, expo_id)
      # toggle visibility of closest parent div.nested-fields
      $start_point.slideToggle()

  prefill_expo_table()
  $("#tabs li a[href='#expositions']").bind 'click', ->
    $('.nested-fields').hide()

# functions

better_errors_list = ->
  $errors_container = $('ul.dossier_errors')
  $errors_header = $("<p><strong>#{$errors_container.attr('data-model_name')} invalide</strong><br />Veuillez vérifier les champs suivant :</p>")
  $errors_wrap = $('<div class="alert-message block-message error fade in" data-alert="alert" />')
  $errors_container.wrap($errors_wrap)
  $errors_header.prependTo($('.alert-message'))

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

prefill_expo_table = ->
  start_points = $('.nested-fields')

  expo_ids = (collect_expo_id($(start_point)) for start_point in start_points)

  values_set = []
  values_set.push collect_values_to_copy($(start_point)) for start_point in start_points
  append_to_expo_summary(values, expo_ids[i]) for values, i in values_set

collect_expo_id = ($start_point) ->
  expo_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

collect_values_to_copy = ($start_point) ->
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
  return values

append_to_expo_summary = (fields, expo_id) ->
  $target = $("#expositions_summary tbody")
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

  $modify_link = $("<a href='#' id='modify_expo_#{expo_id}'><img alt='M' src='/assets/icons/edit.png'></a>")
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
