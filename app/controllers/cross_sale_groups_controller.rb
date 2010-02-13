class CrossSaleGroupsController < ApplicationController
  require 'inplace'

  # GET /cross_sale_groups
  def index
    @cross_sale_groups = CrossSaleGroup.all
    if request.xhr?
      csg = CrossSaleGroup.find(params[:id])
      render :update do |page|
        page.remove "cross_sale_group_#{csg.id}_new_item_row"
        csg.items.each {|i| page.remove "cross_sale_group_#{csg.id}_item_#{i.id}_row"}
        page.replace_html "record_#{params[:id]}_arrow", :partial => 'right_arrow', :locals => {:csg => csg}
      end
    end
  end

  # GET /cross_sale_groups/1
  def show
    if CrossSaleGroup.exists?(params[:id])
      @cross_sale_group = CrossSaleGroup.find(params[:id])
    else
      flash[:notice] = 'Cannot find a Cross-Sale Group with that ID'
      redirect_to cross_sale_groups_url
    end
  end

  # GET /cross_sale_groups/new
  def new
    @cross_sale_group = CrossSaleGroup.new
  end

  # GET /cross_sale_groups/1/edit
  def edit
    @cross_sale_group = CrossSaleGroup.find(params[:id])
    if request.xhr?
      render :update do |page|
        page.replace_html "record_#{params[:id]}_arrow", :partial => 'down_arrow', :locals => {:csg => @cross_sale_group}
        page.insert_html :after, "record_#{params[:id]}_row", :partial => 'items_form', :locals => {:csg => @cross_sale_group}
      end
    else
      flash[:notice] = 'Sorry - we haven\'t created a form for that yet.'
      redirect_to cross_sale_groups_url
    end
  end

  # POST /cross_sale_group
  def create
    @cross_sale_group = CrossSaleGroup.new(params[:cross_sale_group])
    if @cross_sale_group.save
      if request.xhr?
        render :update do |page|
          page.insert_html :bottom, 'record_list_div', :partial => 'individual_record_listing', :locals => {:csg => @cross_sale_group}
          page.replace_html 'add_record_div', :partial => 'add_fields', :layout => false
        end
      else
        flash[:notice] = 'Cross-Sale Group was successfully created.'
        redirect_to cross_sale_groups_url
      end
    else
      flash[:notice] = 'There was a problem creating that Cross-Sale Group.'
      render :action => 'new'
    end
  end

  # PUT /cross_sale_group/1
  def update
    @cross_sale_group = CrossSaleGroup.find(params[:id])
    respond_to do |format|
      if @cross_sale_group.update_attributes(params[:cross_sale_group])
        format.html {flash[:notice] = 'Cross-Sale Group was successfully updated.'; redirect_to cross_sale_groups_url}
        format.json {render :json => @cross_sale_group}
      else
        format.html {render :action => 'edit'}
        format.json {render :json => @cross_sale_group, :status => 500}
      end
    end
  end

  # DELETE /cross_sale_group/1
  def destroy
    csg = CrossSaleGroup.find(params[:id])
    if request.xhr?
      render :update do |page|
        # Remove main record
        page.remove "record_#{csg.id}_row"
        # Remove new record field if it exists
        page << "if($('cross_sale_group_#{csg.id}_new_item_row')) {"
          page.remove "cross_sale_group_#{csg.id}_new_item_row"
        page << "}"
        # Remove each item row if they exist
        csg.items.each do |i|
          page << "if($('cross_sale_group_#{csg.id}_item_#{i.id}_row')) {"
            page.remove "cross_sale_group_#{csg.id}_item_#{i.id}_row"
          page << "}"
        end
      end
    else
      flash[:notice] = 'Cannot delete a Cross-Sale Group without JavaScript.'
      redirect_to cross_sale_groups_url
    end
    Item.find(:all, :conditions => {:cross_sale_group_id => csg.id}).each do |i|
      i.update_attribute :cross_sale_group_id, nil
    end
    csg.destroy
  end

  # JS: Show "new record" form fields
  def show_add_fields
    render :partial => 'add_fields', :layout => false if request.xhr?
  end

  # JS: Show "add record" button
  def show_add_button
    render :partial => 'add_button', :layout => false if request.xhr?
  end

  # POST /cross_sale_group/1/item/1
  def associate_item
    cross_sale_group = CrossSaleGroup.find(params[:id])
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      cross_sale_group.items << item
      if request.xhr?
        render :update do |page|
          page.insert_html :before,
            "cross_sale_group_#{cross_sale_group.id}_new_item_row",
            :partial => 'group_item',
            :locals => {:csg => cross_sale_group, :i => item}
          page.replace_html "cross_sale_group_#{cross_sale_group.id}_new_item_cell",
            :partial => 'new_group_item', :locals => {:csg => cross_sale_group}
        end
      else
        flash[:notice] = 'Item successfully associated with Cross-Sale Group'
        redirect_to cross_sale_groups_url
      end
    else
      if request.xhr?
        render :update do |page|
          page.insert_html :bottom,
            "cross_sale_group_#{cross_sale_group.id}_new_item_cell",
            'Could not find an item with that ID'
        end
      else
        flash[:notice] = 'Could not find an item with that ID'
        redirect_to cross_sale_groups_url
      end
    end
  end

  # DELETE /cross_sale_group/1/items/1
  def dissociate_item
    cross_sale_group = CrossSaleGroup.find(params[:id])
    if cross_sale_group.items.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      cross_sale_group.items.delete(item)
      if request.xhr?
        render :update do |page|
          page.remove "cross_sale_group_#{cross_sale_group.id}_item_#{item.id}_row"
        end
      else
        flash[:notice] = 'Item successfully dissociated from Cross-Sale Group'
        redirect_to edit_cross_sale_group_url(cross_sale_group)
      end
    else
      flash[:notice] = 'Could not find an associated item with that ID'
      redirect_to show_cross_sale_group_url(cross_sale_group)
    end
  end
end
