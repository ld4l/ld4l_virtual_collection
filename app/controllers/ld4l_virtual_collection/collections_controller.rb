require_dependency "ld4l_virtual_collection/application_controller"

module Ld4lVirtualCollection
  class CollectionsController < ApplicationController
    before_action :set_collection, only: [:show, :edit, :update, :destroy]

    # GET /collections
    def index
      @collections = Collection.all
    end

    # GET /collections/1
    def show
    end

    # GET /collections/new
    def new
      @collection = Collection.new
    end

    # GET /collections/1/edit
    def edit
    end

    # POST /collections
    def create
      @collection = Collection.new(collection_params)

      if LD4L::OreRDF::PersistAggregation.call(@collection)[:aggregation_resource_persisted]
        redirect_to @collection, notice: 'Collection was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /collections/1
    def update
      @collection = Collection.update(@collection,collection_params)

      # TODO -- should update check that proxies persisted as well???
      if LD4L::OreRDF::PersistAggregation.call(@collection.update(collection_params))[:aggregation_resource_persisted]
        redirect_to @collection, notice: 'Collection was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /collections/1
    def destroy
      @collection.destroy
      redirect_to collections_url, notice: 'Collection was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_collection
        # TODO -- need to implement destroy in ORE Gem
      @collection = Collection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collection_params
        params[:collection]
      end
  end
end
