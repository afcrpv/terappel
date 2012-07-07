window.initDossiersDatatable = ->
  dossiers_table = $("#dossiers").dataTable
    oLanguage:
       #French translation
        #@name French
        #@anchor French
        #@author Guillaume LO RE

      "sProcessing":     "Traitement en cours..."
      "sLengthMenu":     "Afficher _MENU_ dossiers"
      "sZeroRecords":    "Aucun dossier &agrave; afficher"
      "sInfo":           "Affichage du dossier _START_ &agrave; _END_ sur _TOTAL_ dossiers"
      "sInfoEmpty":      "Affichage de dossier 0 &agrave; 0 sur 0 dossiers"
      "sInfoFiltered":   "(filtr&eacute; de _MAX_ dossiers au total)"
      "sInfoPostFix":    ""
      "sSearch":         "Nom patiente&nbsp;:"
      "sLoadingRecords": "Téléchargement..."
      "sUrl":            ""
      "oPaginate":
        "sFirst":    "Premi&egravere"
        "sPrevious": "Pr&eacute;c&eacute;dente"
        "sNext":     "Suivante"
        "sLast":     "Derni&egravere"
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    sPaginationType: "bootstrap"
    bProcessing: true
    aoColumnDefs: [
      { bSortable: false, aTargets: [4, 6, 7, 8]}
      { sWidth: "80px", aTargets: [ -1 ] }
      { sWidth: "150px", aTargets: [ 2, 4 ] }
    ]

