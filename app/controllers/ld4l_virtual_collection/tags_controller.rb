require_dependency "ld4l_virtual_collection/application_controller"

module Ld4lVirtualCollection
  class TagsController < ApplicationController
    before_action :set_collection_and_item, only: [:new, :create, :index]
    before_action :set_item, only: [:manage_all]
    before_action :set_tag, only: [:show, :edit, :update, :destroy]

    # GET /collections/1/tags
    # GET /collections/1/items/1/tags
    def index
      @tags = Tag.all(@collection,@item)
    end

    # GET /tags/1
    def show
    end

    # GET /collections/1/tags/new
    # GET /collections/1/items/1/tags/new
    def new
      # puts("*** Entering CTRL: new tag")
      @tag = Tag.new(@collection,@item)
    end

    # GET /tags/1/edit
    def edit
      # puts("*** Entering CTRL: edit tag")
    end

    # POST /collections/1/items/1/tags
    def create
      # puts("*** Entering CTRL: create tag")
      @tag = Tag.new(@item, tag_params)
      # TODO: Any error checking that the ones to delete are deleted and the ones to add are added?
      if @tag.persist! == true
        redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Tag was successfully created.'
      else
        # TODO How to add error message about what failed to persist???
        render :new
      end
    end

    # PATCH/PUT /item/1/tags
    def manage_all
      # puts("*** Entering CTRL: manage_all tag")
      @tags = Tag.update_all(@item, tag_params)
      @tags[:delete_list].each { |t| t.destroy! }
      @tags[:add_list].each    { |t| t.persist! }
      # TODO: Any error checking that the ones to delete are deleted and the ones to add are added?
      # if @tag.persist! == true
        redirect_to my_virtual_collection_path(tag_params[:collection_id]), notice: 'Tags were successfully set.'
      # else
      #   # TODO How to add error message about what failed to persist???
      #   render :new
      # end
    end

    # PATCH/PUT /tags/1
    def update
      # puts("*** Entering CTRL: update tag")
      @tag = Tag.update(@tag, tag_params)
      if @tag.persist! == true
        redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Tag were successfully updated.'
      else
        # TODO How to add error message about what failed to persist???
        render :edit
      end
    end

    # DELETE /tags/1
    def destroy
      # puts("*** Entering CTRL: destroy tag")
      @tag.destroy
      # if LD4L::OreRDF::DestroyProxy.call(@collection,@item.rdf_subject) == true
      redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Tag was successfully removed.'
      # else
      #   # TODO Should it redirect to edit???  OR list???  OR  where???
      #   # TODO How to add error message about what failed to be destroyed???
      #  render :edit
      # end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tag
        @tag = Tag.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def tag_params
        params[:tag]
      end

      def set_collection_and_item
        @collection = Collection.find(tag_params["collection_id"])
        @item = Item.find(tag_params["item_id"])
        @proxy_for = @item && @item.proxy_for && @item.proxy_for.first ? @item.proxy_for.first.rdf_subject : ""
      end

      def set_item
        @item = Item.find(tag_params["item_id"])
      end
  end
end
