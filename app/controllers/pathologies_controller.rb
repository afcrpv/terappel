class PathologiesController < ApplicationController
  load_and_authorize_resource

  def index
    @pathologies = Pathology.search_by_name(params[:q])
    respond_to do |format|
      format.json { render json: @pathologies.leaves.map(&:libelle_and_id) }
    end
  end

  def tree
    respond_to do |format|
      format.html
      format.json do
        nodes = []
        root = Pathology.roots.first
        nodes << { id: root.id, parent: '#', text: root.libelle,
                   state: { opened: true, selected: params[:selected].split(',').include?(root.id.to_s), disabled: true } }
        root.descendants.each do |node|
          nodes << {
            id: node.id,
            parent: node.ancestry.split('/').last,
            text: node.libabr.present? ? [node.libabr, node.libelle].join(' - ') : node.libelle,
            state: { opened: node.is_childless?, selected: params[:selected].split(',').include?(node.id.to_s), disabled: node.has_children? }
          }
        end
        render json: nodes
      end
    end
  end
end
