window.initDossierDialog = ->
  # jquery dialog for dossier preview
  $dialog = $(".dialog")
  $dialog.dialog
    autoOpen: false
    modal: true
    width: 980

  $(".opener").on 'click', (event) ->
    event.preventDefault()
    dossier_id = $(this).attr("id")
    $dossier_dialog = $("#dossier_#{dossier_id}_modal")
    dossier_edit_url = $dossier_dialog.attr("data-edit")
    dossier_show_url = $dossier_dialog.attr("data-show")
    dialog_title = $dossier_dialog.attr("data-title")

    dialog_buttons = {}

    if $dossier_dialog.attr("data-edit")
      dialog_buttons["Modifier"] =
        text: "Modifier ce dossier"
        "class": "btn btn-info"
        click: -> window.location = dossier_edit_url
    if $dossier_dialog.attr("data-show")
      dialog_buttons["Voir"] =
        text: "Détails du dossier"
        "class": "btn btn-primary"
        click: -> window.location = dossier_show_url

    $dossier_dialog.dialog(
      buttons: dialog_buttons
      title: dialog_title)
    .dialog('open')
