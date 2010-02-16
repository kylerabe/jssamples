class ItemsController < ApplicationController
  before_filter :get_item_from_id

  def index
    @items = Item.all
  end

  def show; end

  def edit; end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = 'Item created successfully'
      redirect_to items_url
    else
      render :new
    end
  end

  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = 'Item updated successfully'
      redirect_to items_url
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item destroyed successfully'
    redirect_to items_url
  end

  private

  def get_item_from_id
    if !params[:id]
      # continue
    elsif Item.exists?(params[:id])
      @item = Item.find(params[:id])
    else
      flash[:notice] = 'Could not find item with that ID'
      redirect_to items_url
    end
  end
end
