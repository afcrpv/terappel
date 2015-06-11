class DcisController < ApplicationController
  respond_to :json
  load_and_authorize_resource

  def index
    @dcis = if params[:dci_id]
              Dci.where(id: params[:dci_id])
            else
              Dci.search_by_name(params[:q])
            end
    respond_with @dcis.map(&:name_and_id)
  end
end
