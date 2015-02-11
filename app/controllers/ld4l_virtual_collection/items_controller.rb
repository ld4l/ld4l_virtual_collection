require_dependency "ld4l_virtual_collection/application_controller"

module Ld4lVirtualCollection
  class ItemsController < ApplicationController
    before_action :set_collection
    before_action :set_item, only: [:show, :edit, :update, :destroy, :metadata_from_uri]

    # GET /collections/1/items
    def index
      @items = Item.all(@collection)
    end

    # GET /collections/1/items/1
    def show
    end

    # GET /collections/1/items/new
    def new
      puts("*** Entering CTRL: new item")
      @item = Item.new(@collection)
      @proxy_for = ""
    end

    # GET /items/1/edit
    def edit
      puts("*** Entering CTRL: edit item")
    end

    # POST /collections/1/items
    def create
      puts("*** Entering CTRL: create item")
      @item = Item.new(@collection, item_params)

      # TODO How to save only affected items & collection instead of all items & collection???
      if LD4L::OreRDF::PersistAggregation.call(@collection) == true
        redirect_to collection_path(@collection.id.to_s), notice: 'Item was successfully created.'
      else
        # TODO How to add error message about what failed to persist???
        render :new
      end
    end

    # PATCH/PUT /collections/1/items/1
    def update
      puts("*** Entering CTRL: update item")
      @item = Item.update(@collection, @item, item_params)
      # TODO How to save only affected items & collection instead of all items & collection???
      if LD4L::OreRDF::PersistAggregation.call(@collection) == true
        redirect_to collection_path(@collection.id.to_s), notice: 'Item was successfully updated.'
      else
        render :edit
      end
    end

    # GET /collections/1/items/1
    def metadata_from_uri
      puts("*** Entering CTRL: create_from_uri (item)")
      LD4L::WorksRDF::GetMetadataFromURI(@proxy_for)
    end

    # DELETE /collections/1/items/1
    def destroy
      puts("*** Entering CTRL: destroy item")
      # TODO -- need to implement destroy in ORE Gem -- Destroying just the item leaves the aggregates triples
      @item.destroy   ## TODO REMOVE THIS LINE WHEN DestroyProxy IS IMPLEMENTED
      # if LD4L::OreRDF::DestroyProxy.call(@collection,@item.rdf_subject) == true
      redirect_to collection_path(@collection.id.to_s), notice: 'Item was successfully removed.'
      # else
      #   # TODO Should it redirect to edit???  OR list???  OR  where???
      #   # TODO How to add error message about what failed to be destroyed???
      #  render :edit
      # end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = Item.find(params[:id])
        @proxy_for = @item && @item.proxy_for && @item.proxy_for.first ? @item.proxy_for.first.rdf_subject : ""
      end

      # Only allow a trusted parameter "white list" through.
      def item_params
        params[:item]
      end

      def set_collection
        @collection = Collection.find(params["collection_id"])
      end
  end
end
