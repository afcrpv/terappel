jQuery ->
  malformation_jstree_data =
    "json_data" :
      "ajax" :
        "url" : "/malformations/tree.json"
        "data" : (node) ->
          return { parent_id : if node.attr then node.attr("id") else 0}
    plugins: ["themes", "json_data", "ui", "checkbox"]
    themes:
      theme: 'apple'
    checkbox:
      override_ui: true
      two_state: true

  $(".malformations_tree")
    .bind "loaded.jstree", (event, data) ->
      console.log "tree##{$(this).attr('class')} is loaded"
    .jstree(malformation_jstree_data)
    .bind "check_node.jstree uncheck_node.jstree", (event, data) ->
      # assign the following to check/uncheck node events
      nodes = $(this).jstree("get_checked")
      checked_nodes_objs = []
      checked_nodes_objs.push {id: $(node).attr("id"), libelle: $(node).attr("libelle")} for node in nodes
      names = []
      names.push(obj.libelle) for obj in checked_nodes_objs
      html = []
      html.push "<ul>"
      html.push "<li>#{name}</li>" for name in names
      html.push "</ul>"
      # create a list with malformations checked nodes
      $(this).parent().next().find(".malformations_container").html(html.join(""))
      $(this).parent().next().find("a").bind "click", (event) ->
        # assign action to add checked malformations to be persisted in db
        event.preventDefault()
        $tokeninput = $(this).parents('body').find(".nested-fields:visible").find("textarea[id$=malformation_tokens]")
        $modal = $(this).parents(".modal")
        $modal.modal('hide')
        $tokeninput.tokenInput("add", obj) for obj in checked_nodes_objs

  $(".modify_link").bind 'click', ->
    $malformation_tree_button = $("a.show_malformation_tree:visible")
    $add_malformations_button = $("a.add_malformations:visible")
    $malformation_tree_button.complete_modal_for_association("malformation")

jQuery.fn.complete_modal_for_association = (association) ->
  if this.length
    bebe_id = this.prevAll("input").attr("id").match(/[0-9]+/).join()
    association_modal_id = "#{association}_bebe_#{bebe_id}_modal"
    $modal = this.parent().next(".modal")
    this.attr("data-controls-modal", association_modal_id)
    $modal.attr("id", association_modal_id)
