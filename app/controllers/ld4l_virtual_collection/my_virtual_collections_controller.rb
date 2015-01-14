require_dependency "ld4l_virtual_collection/application_controller"

module Ld4lVirtualCollection
  class MyVirtualCollectionsController < ApplicationController
    before_action :set_my_virtual_collection, only: [:show, :edit, :update, :destroy]

    # GET /my_virtual_collections
    def index
      @my_virtual_collections = MyVirtualCollection.all
    end

    # GET /my_virtual_collections/1
    def show
    end

    # GET /my_virtual_collections/new
    def new
      @my_virtual_collection = MyVirtualCollection.new
    end

    # GET /my_virtual_collections/1/edit
    def edit
    end

    # POST /my_virtual_collections
    def create
      @my_virtual_collection = MyVirtualCollection.new(my_virtual_collection_params)

      if @my_virtual_collection.save
        redirect_to @my_virtual_collection, notice: 'My virtual collection was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /my_virtual_collections/1
    def update
      if @my_virtual_collection.update(my_virtual_collection_params)
        redirect_to @my_virtual_collection, notice: 'My virtual collection was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /my_virtual_collections/1
    def destroy
      @my_virtual_collection.destroy
      redirect_to my_virtual_collections_url, notice: 'My virtual collection was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_my_virtual_collection
        @my_virtual_collection = MyVirtualCollection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def my_virtual_collection_params
        params[:my_virtual_collection]
      end
  end
end
