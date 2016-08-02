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
end
