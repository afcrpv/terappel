class HomeController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :dossier, :code, :full => true

  def index
  end

  def try_new_dossier
    @code = params[:code]
  end
end
