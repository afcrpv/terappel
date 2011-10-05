class CentresController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @dossiers = @centre.dossiers
  end
end
