# require 'ruby-prof'
require_dependency "ld4l_virtual_collection/application_controller"


# TODO This code implies that @collection is an instance of the Collection model, but it is actually an instance of
#      LD4L::OreRDF::Aggregation.  Should the Collection model be updated to hold the instance of LD4L::OreRDF::Aggregation
#      and have the methods updated to redirect to the Aggregation model?  OR should Collection inherit from
#      LD4L::OreRDF::Aggregation and get the methods that way?  That seems the cleaner way to go.


module Ld4lVirtualCollection
  class CollectionsController < ApplicationController
    before_action :set_collection, only: [:show, :edit, :update, :destroy]

    # GET /collections
    def index
      @collections = Collection.all
    end

    # GET /collections/1
    def show
      # puts("*** Entering CTRL: show collection")
    end

    # GET /collections/new
    def new
      # puts("*** Entering CTRL: new collection")
      @collection = Collection.new
    end

    # GET /collections/1/edit
    def edit
      # puts("*** Entering CTRL: edit")
    end

    # POST /collections
    def create
# RubyProf.start
# binding.pry
      # puts("*** Entering CTRL: create collection")
      @collection = Collection.new(collection_params)
      persisted = false
      error_msg = ''
      begin
        persisted = LD4L::OreRDF::PersistAggregation.call(@collection)
      rescue ArgumentError
        # TODO should check that error message from ArgumentError is that Title is missing.
        error_msg = "Title is required."
      end
      if persisted == true
        flash[:notice] = 'Collection was successfully created.'
        redirect_to my_virtual_collection_path(@collection.id.to_s)
      else
        flash[:error] = "Collection not created.  #{error_msg}"
        redirect_to my_virtual_collections_path
      end
# result = RubyProf.stop
# File.open("profile/analysis/vc_collection_create.html", "w") do |file|
#   RubyProf::GraphHtmlPrinter.new(result).print(file)
# end
    end

    # PATCH/PUT /collections/1
    def update
      # puts("*** Entering CTRL: update collection")
      @collection = Collection.update(collection_params)
      persisted = false
      error_msg = ''
      begin
        # TODO -- should update check that proxies persisted as well???
        persisted = LD4L::OreRDF::PersistAggregation.call(@collection)
      rescue ArgumentError
        # TODO should check that error message from ArgumentError is that Title is missing.
        error_msg = "Title is required."
      end
      if persisted == true
        flash[:notice] = 'Collection was successfully updated.'
        redirect_to my_virtual_collection_path(@collection.id.to_s)
      else
        flash[:error] = "Collection not updated.  #{error_msg}"
        redirect_to my_virtual_collections_path
      end
    end

    # DELETE /collections/1
    def destroy
      # puts("*** Entering CTRL: destroy collection")
      if LD4L::OreRDF::DestroyAggregation.call(@collection) == true
        redirect_to my_virtual_collections_path, notice: 'Collection was successfully destroyed.'
      else
        # TODO Should it redirect to edit???  OR list???  OR  where???
        # TODO How to add error message about what failed to be destroyed???
        render :edit
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_collection
        @collection = Collection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collection_params
        params[:collection]
      end
  end
end
