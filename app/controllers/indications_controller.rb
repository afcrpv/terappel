class IndicationsController < ApplicationController
  respond_to :json
  load_and_authorize_resource

  def index
    @indications = if params[:indication_id]
                     Indication.where(id: params[:indication_id])
                   else
                     Indication.search_by_name(params[:q])
                   end
    respond_with @indications.leaves.map(&:name_and_id)
  end

  def tree
    respond_to do |format|
      format.json do
        nodes = []
        root = params[:id].present? ? Maladie.find(params[:id]) : Maladie.roots.first
        root.children.sort_by { |c| c.code.to_i }.each do |node|
          nodes << { id: node.id, text: node.libelle, children: node.has_children?, state: { disabled: node.has_children? } }
        end
        render json: nodes
      end
    end
  end
end
