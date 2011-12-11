# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# jquery tabs
jQuery ->
  $("#tabs").tabs()
  $(".validate_expo").live 'click', (event) ->
    $this = $(this)
    event.preventDefault() # prevent default event behavior
    $start_point = $this.closest("ol")
    # collect produit, expo_terme, indication, dose, de, a, de2, a2 fields
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
    # if fields to copy aren't all blank
    if fields_to_copy[0..7].join("") isnt ""
      append_to_expo_summary($("#expositions_summary tbody "), fields_to_copy)
      $start_point.closest(".nested-fields").slideToggle()

append_to_expo_summary = ($target, fields) ->
    # check for row having last td equal to current expo id
    if $target.find("tr td:last").text() isnt fields[8]
      # append an empty tr to last tr element
      $target.find("tr:last").after('<tr></tr>')
      $new_target = $target.find("tr:last")
      # create a cell with a modify action link
      cell_for_modify_action($new_target, fields[8]).bind 'click', (event) ->
        event.preventDefault() # prevent default event behavior
        $(this).parents().find(".nested-fields").has("li[id*='#{fields[8]}']").slideToggle()
      # attach the modify behavior
      # create cells with fields
      create_cells $target.find("tr:last"), field for field in fields
    else
      # find row with corresponding expo id and empty existing cells
      $expo_row = $target.find("tr").filter( -> $(this).find("td:last").text() is fields[8]).empty()
      # recreate a cell with a modify action link
      cell_for_modify_action($expo_row, fields[8])
      # update cells
      create_cells $expo_row, field for field in fields

create_cells = ($node, text) ->
    $node.append("<td>#{text}</td>")

cell_for_modify_action = ($node, expo_id) ->
    $node.append("<td></td>").html("<a href='#' id='modify_expo_#{expo_id}'>M</a>")
