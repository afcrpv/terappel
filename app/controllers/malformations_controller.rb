class MalformationsController < ApplicationController
  def index
    @malformations = Malformation.where("LOWER(libelle) like ?", "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render :json => @malformations.map(&:libelle_and_id) }
    end
  end

  def ancestors
    respond_to do |format|
      format.json do
        ancestors_list = Malformation.find(params[:id]).ancestor_ids.map {|id| "#{id}"}
        render json: ancestors_list
      end
    end
  end

  def tree
    respond_to do |format|
      format.html
      format.json do
        root = Malformation.find(params[:parent_id]) rescue nil
        nodes = root ? root.children : Malformation.roots

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
