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
        root = Maladie.where(code: '16').first
        nodes << { id: root.id, parent: '#', text: root.libelle,
                   state: { opened: true, selected: params[:selected].split(',').include?(root.id.to_s) } }
        root.descendants.sort_by(&:code).each do |node|
          nodes << {
            id: node.id,
            parent: node.ancestry.split('/').last,
            text: node.libelle,
            state: { opened: !node.has_children?, selected: params[:selected].split(',').include?(node.id.to_s) }
          }
        end
        render json: nodes
      end
    end
  end
end
