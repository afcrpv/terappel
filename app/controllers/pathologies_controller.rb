class PathologiesController < ApplicationController
  load_and_authorize_resource

  def index
    @pathologies = Pathology.where('LOWER(libelle) like ?', "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render json: @pathologies.map(&:libelle_and_id) }
    end
  end

  def tree
    respond_to do |format|
      format.html
      format.json do
        nodes = []
        root = Pathology.roots.first
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
        # root = begin
        #          Pathology.find(params[:parent_id])
        #        rescue
        #          nil
        #        end
        # nodes = root ? root.children : Pathology.roots

        # node_hashes = nodes.map do |node|
        #   node_hash = {
        #     attr: { id: node.id, libelle: node.libelle }
        #   }

        #   node_hash[:data] = node.libabr.nil? ?
        #     { title: node.libelle } :
        #     { title: node.libabr + ' - ' + node.libelle }
        #   node_hash[:state] = 'closed' if node.has_children?
        #   node_hash
        # end

        # render json: node_hashes
      # end
    end
  end
end
