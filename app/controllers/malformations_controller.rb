class MalformationsController < ApplicationController
  load_and_authorize_resource

  def index
    @malformations = Malformation.where('LOWER(libelle) like ?', "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render json: @malformations.map(&:libelle_and_id) }
    end
  end

  def tree
    respond_to do |format|
      format.html
      format.json do
        nodes = []
        root = Malformation.roots.first
        nodes << { id: root.id, parent: '#', text: root.libelle,
                   state: { opened: true, selected: params[:selected].split(',').include?(root.id.to_s) } }
        root.descendants.each do |node|
          nodes << {
            id: node.id,
            parent: node.ancestry.split('/').last,
            text: node.libabr.present? ? [node.libabr, node.libelle].join(' - ') : node.libelle,
            state: { opened: !node.has_children?, selected: params[:selected].split(',').include?(node.id.to_s) }
          }
        end
        render json: nodes
      end
    end
  end
end
