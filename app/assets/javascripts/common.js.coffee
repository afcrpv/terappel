$ = jQuery

$ ->
  $(".alert-message").alert()
  $("[rel=tooltip]").tooltip
    delay:
      show: 500
      hide: 100
