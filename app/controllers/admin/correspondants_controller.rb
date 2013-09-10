class Admin::CorrespondantsController < ApplicationController
  respond_to :html
  load_and_authorize_resource :correspondant

  def index
    @corre
  end
end
