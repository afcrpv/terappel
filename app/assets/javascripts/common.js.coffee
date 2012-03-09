$ = jQuery

$ ->
  $(".alert-message").alert()
  $("[rel=tooltip]").tooltip
    delay:
      hide: 100
  $(".dropdown-toggle").dropdown()
