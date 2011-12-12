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
    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields, also get the unique id of the expo
    fields_to_copy = [
      $start_point.find("select[name*='produit'] option").filter(":selected").text()
      $start_point.find("select[name*='expo_terme'] option").filter(":selected").text()
      $start_point.find("select[name*='indication'] option").filter(":selected").text()
      $start_point.find("input[id$='_dose']").val()
      $start_point.find("input[id$='_de']").val()
      $start_point.find("input[id$='_a']").val()
      $start_point.find("input[id$='_de2']").val()
      $start_point.find("input[id$='_a2']").val()
      $start_point.find("select").filter(":first").attr("name").match(/[0-9]+/).join()
    ]
    # don't do anything if fields to copy are all blank
    if fields_to_copy[0..7].join("") isnt ""
      append_to_expo_summary($("#expositions_summary tbody "), fields_to_copy)
      # toggle visibility of closest parent div.nested-fields
      $start_point.closest(".nested-fields").slideToggle()

append_to_expo_summary = ($target, fields) ->
  expo_id = fields[8]

  # check whether a row with id equal to collected expo id exists
  $expo_row = if $target.find("tr#expo_#{expo_id}").length isnt 0 then $target.find("tr#expo_#{expo_id}") else $("<tr id='expo_#{expo_id}' />")

  $expo_row.empty() # empty contents needed to update cells if existing row

  # create a cell with a modify action link
  cell_for_modify_action($expo_row, expo_id).bind 'click', (event) ->
    event.preventDefault()
    # clicking the link toggles the div.nested-fields containing the related expo form
    $(this).parents().find(".nested-fields").has("li[id*='#{expo_id}']").slideToggle()

  # create cells with collected fields
  create_cells $expo_row, field for field in fields

  $expo_row.appendTo($target)

create_cells = ($node, text) ->
  $node.append("<td>#{text}</td>")

cell_for_modify_action = ($node, expo_id) ->
  # append a td containing a link with id equal modify_expo_#expo_id
  $node.append("<td><a href='#' id='modify_expo_#{expo_id}'>M</a></td>")
  return $node.find('a')
