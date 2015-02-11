require 'pry'
require_dependency "ld4l_virtual_collection/application_controller"


# TODO This code implies that @collection is an instance of the Collection model, but it is actually an instance of
#      LD4L::OreRDF::Aggregation.  Should the Collection model be updated to hold the instance of LD4L::OreRDF::Aggregation
#      and have the methods updated to redirect to the Aggregation model?  OR should Collection inherit from
#      LD4L::OreRDF::Aggregation and get the methods that way?  That seems the cleaner way to go.


module Ld4lVirtualCollection
  class MyVirtualCollectionsController < ApplicationController
    before_action :set_collections
    before_action :set_collection_and_items, only: [:show, :edit, :update, :destroy, :edit_collection_modal]

    # GET /my_virtual_collections
    def index
      @collection = Collection.new
    end

    # GET /my_virtual_collections/1
    def show
      puts("*** Entering CTRL: show virtual collection")
    end

    # GET /my_virtual_collections/new_collection_modal
    def new_collection_modal
      puts("*** Entering CTRL: new virtual collection")
      @collection = Collection.new
      respond_to do |format|
        format.html
        format.js
      end
    end

    # POST /my_virtual_collections
    def create
      puts("*** Entering CTRL: create virtual collection")
      @collection = Collection.new(my_virtual_collection_params)
      if LD4L::OreRDF::PersistAggregation.call(@collection) == true
        redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Collection was successfully created.'
      else
        # TODO How to add error message about what failed to persist???
        render :new
      end
    end

    # GET /my_virtual_collections/edit_collection_modal/1
    def edit_collection_modal
      puts("*** Entering CTRL: edit virtual collection")
      respond_to do |format|
        format.html
        format.js
      end
    end


    # PATCH/PUT /my_virtual_collections/1
    def update
      puts("*** Entering CTRL: update virtual collection")
      @collection = Collection.update(my_virtual_collection_params)
      # TODO -- should update check that proxies persisted as well???
      if LD4L::OreRDF::PersistAggregation.call(@collection) == true
        redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Collection was successfully updated.'
      else
        # TODO How to add error message about what failed to persist???
        render :edit
      end
    end

    # DELETE /collections/1
    def destroy
      puts("*** Entering CTRL: destroy virtual collection")
      if LD4L::OreRDF::DestroyAggregation.call(@collection) == true
        redirect_to action: "index", notice: 'Collection was successfully destroyed.'
      else
        # TODO Should it redirect to edit???  OR list???  OR  where???
        # TODO How to add error message about what failed to be destroyed???
        render :edit
      end
    end


    # # GET /my_virtual_collections/1/edit
    # def edit
    #   # puts("*** Entering CTRL: edit")
    # end
    #
    # # POST /my_virtual_collections
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
    # # PATCH/PUT /my_virtual_collections/1
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
    # # DELETE /my_virtual_collections/1
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
        @items = []
        if @collection
# binding.pry
          @collection.proxy_resources.each do |proxy|
            uri = proxy.proxy_for.first.rdf_subject.to_s
            parsable_uri = URI(uri)
# binding.pry
            if( parsable_uri.host == "localhost" || parsable_uri.host == "newcatalog.library.cornell.edu" )
              item_metadata = LD4L::WorksRDF::WorkMetadata.new(nil)
              # ids = [ uri ]
              # @response, @document_list = get_solr_response_for_field_values(SolrDocument.unique_key, ids)
binding.pry

              path = MetadataCallback.metadata_path(:id => "4636067")+".json"

              x = redirect_to path
binding.pry

              Ld4lVirtualCollection::Engine.configuration.metadata_callback.call( { uri => item_metadata } )
              item_metadata.set_type_to_book
              item_metadata.set_source_to_cornell_library
              # item_metadata.title = 'TEST TITLE'
              # item_metadata.author = 'TEST AUTHOR'
            elsif
              item_metadata = LD4L::WorksRDF::GetMetadataFromURI.call(proxy.proxy_for.first.rdf_subject.to_s)
            end
            @items << { :proxy => proxy, :metadata => item_metadata }
            @proxy_for = uri
          end
        end
        # TODO: Following 3 values are kludged for first page.  Need better method for calculating when multiple pages.
        @first_idx  = @items.size > 0 ? 1 : 0
        @last_idx   = @items.size <= 20 ? @items.size : 20
        @num_items  = @items.size
      end

    # Only allow a trusted parameter "white list" through.
      def my_virtual_collection_params
        params[:collection]
      end
  end
end
