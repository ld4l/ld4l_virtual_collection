require 'pry'
require_dependency "ld4l_virtual_collection/application_controller"


# TODO This code implies that @collection is an instance of the Collection model, but it is actually an instance of
#      LD4L::OreRDF::Aggregation.  Should the Collection model be updated to hold the instance of LD4L::OreRDF::Aggregation
#      and have the methods updated to redirect to the Aggregation model?  OR should Collection inherit from
#      LD4L::OreRDF::Aggregation and get the methods that way?  That seems the cleaner way to go.


module Ld4lVirtualCollection
  class MyVirtualCollectionsController < ApplicationController
    before_action :set_collections
    before_action :set_collection_and_items, only: [:show, :edit, :update, :destroy]

    # GET /collections
    def index
    end

    # GET /collections/1
    def show
    end

    # # GET /collections/new
    # def new
    #   puts("*** Entering CTRL: new collection")
    #   @collection = Collection.new
    # end
    #
    # # GET /collections/1/edit
    # def edit
    #   # puts("*** Entering CTRL: edit")
    # end
    #
    # # POST /collections
    # def create
    #   puts("*** Entering CTRL: create collection")
    #   @collection = Collection.new(collection_params)
    #   if LD4L::OreRDF::PersistAggregation.call(@collection) == true
    #     redirect_to collection_path(@collection.id.to_s), notice: 'Collection was successfully created.'
    #   else
    #     # TODO How to add error message about what failed to persist???
    #     render :new
    #   end
    # end
    #
    # # PATCH/PUT /collections/1
    # def update
    #   puts("*** Entering CTRL: update collection")
    #   @collection = Collection.update(collection_params)
    #   # TODO -- should update check that proxies persisted as well???
    #   if LD4L::OreRDF::PersistAggregation.call(@collection) == true
    #     redirect_to collection_path(@collection.id.to_s), notice: 'Collection was successfully updated.'
    #   else
    #     # TODO How to add error message about what failed to persist???
    #     render :edit
    #   end
    # end
    #
    # # DELETE /collections/1
    # def destroy
    #   puts("*** Entering CTRL: destroy collection")
    #   if LD4L::OreRDF::DestroyAggregation.call(@collection) == true
    #     redirect_to collections_url, notice: 'Collection was successfully destroyed.'
    #   else
    #     # TODO Should it redirect to edit???  OR list???  OR  where???
    #     # TODO How to add error message about what failed to be destroyed???
    #     render :edit
    #   end
    # end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_collections
        @collections = Collection.all
        # @watched = Watched.all
      end

      def set_collection_and_items
        @select_id  = params[:id]
        @collection = Collection.find(@select_id)
        @items      = @collection.proxy_resources if @collection
        @first_idx  = 1
        @last_idx   = @items.size <= 20 ? @items.size : 20
        @num_items  = @items.size
      end

    # Only allow a trusted parameter "white list" through.
      def my_virtual_collection_params
        params[:collection]
      end
  end
end
