class Admin::ThesaurusController < ApplicationController
  respond_to :html

  before_action :set_name
  before_action :set_item, only: [:edit, :update, :destroy]

  def dashboard
  end

  def index
    klass = @name.classify.constantize
    @items = klass.all
  end

  def new
    @klass = @name.classify.constantize
  end

  def create
    klass = @name.classify.constantize
    @item = klass.create(item_params)
    respond_with @item, location: admin_thesaurus_path(name: @name)
  end

  def edit
  end

  def update
    @item.update(item_params)
    respond_with @item, location: admin_thesaurus_path(name: @name)
  end

  def destroy
    @item.destroy
    respond_with @item, location: admin_thesaurus_path(name: @name)
  end

  private

  def item_params
    params.require(@name).permit(:name)
  end

  def set_name
    @name ||= params[:name]
  end

  def set_item
    klass = @name.classify.constantize
    @item = klass.find(params[:id])
  end
end
