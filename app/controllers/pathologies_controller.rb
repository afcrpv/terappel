class PathologiesController < ApplicationController
  load_and_authorize_resource

  def index
    @pathologies = Pathology.where("LOWER(libelle) like ?", "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render :json => @pathologies.map(&:libelle_and_id) }
    end
  end

  def ancestors
    respond_to do |format|
      format.json do
        ancestors_list = Pathology.find(params[:id]).ancestor_ids.map {|id| "#{id}"}
        render json: ancestors_list
      end
    end
  end

  def tree
    respond_to do |format|
      format.html
      format.json do
        root = Pathology.find(params[:parent_id]) rescue nil
        nodes = root ? root.children : Pathology.roots

        node_hashes = nodes.map do |node|
          node_hash = {
            :attr => { :id => node.id, :libelle => node.libelle }
          }

          node_hash[:data] = node.libabr.nil? ?
            {:title => node.libelle} :
            {:title => node.libabr + " - " + node.libelle}
          node_hash[:state] = 'closed' if node.has_children?
          node_hash
        end

        render :json => node_hashes
      end
    end
  end
end
