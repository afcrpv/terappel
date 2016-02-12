module Admin
  # Administration Tables Generales
  class ThesaurusController < ApplicationController
    respond_to :html

    before_action :set_name, except: :dashboard
    before_action :set_klass, except: :dashboard
    before_action :set_item, only: [:edit, :update, :destroy]

    def dashboard
      authorize! :dashboard, :thesaurus
    end

    def index
      @items = @klass.order(:name)
      respond_with @items
      authorize! :index, :thesaurus
    end

    def new
      @item = @klass.new
      respond_with @item
      authorize! :create, :thesaurus
    end

    def create
      @item = @klass.create(item_params)
      respond_with @item, location: admin_thesaurus_path(name: @name)
      authorize! :create, :thesaurus
    end

    def edit
      respond_with @item
      authorize! :update, :thesaurus
    end

    def update
      @item.update(item_params)
      respond_with @item, location: admin_thesaurus_path(name: @name)
      authorize! :update, :thesaurus
    end

    def destroy
      @item.destroy
      respond_with @item, location: admin_thesaurus_path(name: @name)
      authorize! :destroy, :thesaurus
    end

    private

    def item_params
      params.require(@name).permit(:name, :oldid)
    end

    def set_name
      @name ||= params[:name]
    end

    def set_klass
      @klass ||= allowed_classes.find { |klass| klass.name == @name.classify }
      fail message = "Table '#{@name.tableize}' non trouvée" if @klass.nil?
    rescue
      redirect_to admin_tables_generales_url, alert: message
    end

    def set_item
      @item ||= @klass.find(params[:id])
    end

    def allowed_classes
      [Categoriesp, Motif, Formule, Qualite, Specialite, ExpoNature, ExpoTerme,
       ExpoType, Voie, Indication]
    end
  end
end
