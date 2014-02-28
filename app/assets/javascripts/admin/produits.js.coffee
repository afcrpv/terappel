$ = jQuery

$ ->
  $("#produit_id").select2
    placeholder: "nom du produit"
    minimumInputLength: 2
    ajax:
      url: "/dossiers/produits.json"
      dataType: "json"
      data: (term, page) ->
        q: term
        page_limit: 20
      results: (data, page) ->
        return {results: data}
