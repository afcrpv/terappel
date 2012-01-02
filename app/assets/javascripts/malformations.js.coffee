jQuery ->
  malformation_jstree_data =
    "json_data" :
      "ajax" :
        "url" : "/malformations/tree.json"
        "data" : (node) ->
          return { parent_id : if node.attr then node.attr("id") else 0}
    plugins: ["themes", "json_data", "ui"]
    themes:
      theme: 'apple'

  $(".malformations_tree")
    .bind "loaded.jstree", (event, data) ->
      console.log("tree##{$(this).attr('class')} is loaded")
    .jstree(malformation_jstree_data)

  $(".modify_link").bind 'click', ->
    $malformation_tree_button = $("a.show_malformation_tree:visible")
    $malformation_tree_button.complete_modal_for_association("malformation")

jQuery.fn.complete_modal_for_association = (association) ->
  if this.length
    bebe_id = this.prevAll("input").attr("id").match(/[0-9]+/).join()
    console.log "bebe order in dossier :" + bebe_id
    association_modal_id = "#{association}_bebe_#{bebe_id}_modal"
    $modal = this.parent().next(".modal")
    this.attr("data-controls-modal", association_modal_id)
    $modal.attr("id", association_modal_id)
    console.log "#{association} modal id :" + $modal.attr("id")
