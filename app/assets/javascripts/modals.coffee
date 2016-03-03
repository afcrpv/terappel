$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a[data-modal]', ->
    location = $(this).attr('href')
    correspondant_type = $(this).data('correspondant-type')
    #Load modal dialog from server
    $.get location, (data) ->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
      $('form[data-modal=true]').data('correspondant-type', correspondant_type)

    false
