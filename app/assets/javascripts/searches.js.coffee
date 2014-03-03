# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ = jQuery

$ ->
  $("#search_min_date_appel").mask("99/99/9999")
  $("#search_max_date_appel").mask("99/99/9999")

  prefixes = ["min", "max"]
  dates_fields = []
  dates_fields.push($("#search_#{prefixe}_date_appel")) for prefixe in prefixes

  for date_field in dates_fields
    date_field.mask("99/99/9999")
    value = date_field.attr("data-value")
    date_field.val(value) if value

  $(".row .actions a").addClass("btn")

  for association in ["produit", "indication", "dci"]
    $(".#{association}_autocomplete").attach_expositions_select2(association, "/dossiers/#{association}s.json")

  for name in ["dci", "produit"]
    $(".#{name}_tokens").select2
      minimumInputLength: 3
      multiple: true
      initSelection : (element, callback) ->
        preload = element.data("load")
        callback(preload)
      ajax:
        url: "/dossiers/#{name}s.json"
        dataType: "json"
        data: (term, page) ->
          q: term
          page_limit: 10
        results: (data, page) ->
          return {results: data}

class @Search
  constructor: (@templates = {}) ->

  remove_fields: (button) ->
    $(button).closest('.fields').remove()

  add_fields: (button, type, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp('new_' + type, 'g')
    $(button).before(content.replace(regexp, new_id))

  nest_fields: (button, type) ->
    new_id = new Date().getTime()
    id_regexp = new RegExp('new_' + type, 'g')
    template = @templates[type]
    object_name = $(button).closest('.fields').attr('data-object-name')
    sanitized_object_name = object_name.replace(/\]\[|[^-a-zA-Z0-9:.]/g, '_').replace(/_$/, '')
    template = template.replace(/new_object_name\[/g, object_name + "[")
    template = template.replace(/new_object_name_/, sanitized_object_name + '_')
    $(button).before(template.replace(id_regexp, new_id))
