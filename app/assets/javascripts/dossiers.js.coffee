# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# jquery tabs
jQuery ->
  $("#tabs").tabs()
  $(".validate_expo").live 'click', (event) ->
    $this = $(this)
    event.preventDefault() # prevent default event behavior
    # start point is the closest parent ol node of the link, it contains the fields to copy
    $start_point = $this.closest("ol")

    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields
    values_to_copy = collect_values_to_copy($start_point)

    # also get the unique id of the expo
    expo_id = $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()

    # don't do anything if fields to copy are all blank
    if values_to_copy.join("") isnt ""
      append_to_expo_summary(values_to_copy, expo_id)
      # toggle visibility of closest parent div.nested-fields
      $start_point.closest(".nested-fields").slideToggle()

  prefill_expo_table()

# functions

prefill_expo_table = ->
  #alert "Fired prefill_expo_table!"

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
  $related_fieldset = $node.parents().find(".nested-fields").has("li[id*='#{expo_id}']")

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
