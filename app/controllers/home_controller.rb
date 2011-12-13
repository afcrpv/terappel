class HomeController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :dossier, :code, :full => true

  def index
  end

end
