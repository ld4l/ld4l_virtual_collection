require_dependency "ld4l_virtual_collection/application_controller"


# TODO This code implies that @collection is an instance of the Collection model, but it is actually an instance of
#      LD4L::OreRDF::Aggregation.  Should the Collection model be updated to hold the instance of LD4L::OreRDF::Aggregation
#      and have the methods updated to redirect to the Aggregation model?  OR should Collection inherit from
#      LD4L::OreRDF::Aggregation and get the methods that way?  That seems the cleaner way to go.


module Ld4lVirtualCollection
  class MyVirtualCollectionsController < ApplicationController
    before_action :set_collections
    before_action :set_collection, only: [:edit, :update, :destroy, :edit_collection_modal, :new_collection_item_modal]
    before_action :set_collection_and_items, only: [:show]

    # GET /my_virtual_collections
    def index
      @collection = Collection.new
    end

    # GET /my_virtual_collections/1
    def show
      # puts("*** Entering CTRL: show virtual collection")
    end

    # GET /my_virtual_collections/new_collection_modal
    def new_collection_modal
      # puts("*** Entering CTRL: new virtual collection")
      @collection = Collection.new
      respond_to do |format|
        format.html
        format.js
      end
    end

    # GET /my_virtual_collections/edit_collection_modal/1
    def edit_collection_modal
      # puts("*** Entering CTRL: edit virtual collection")
      respond_to do |format|
        format.html
        format.js
      end
    end


    # GET /my_virtual_collections/new_collection_item_modal/1
    def new_collection_item_modal
      # puts("*** Entering CTRL: new virtual collection item")
      @item = Item.new(@collection)
      @proxy_for = ""
      respond_to do |format|
        format.html
        format.js
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

        # TODO Sorting collections alphabetically...
        # TODO   * @collections is a hash, so it can't be sorted
        # TODO   * need to convert @collections from a hash to an array

        # @watched = Watched.all
      end

      def set_collection
        @select_id  = params[:id]
        @collection = Collection.find(@select_id)
      end

      def set_collection_and_items
        @select_id  = params[:id]
        @collection = Collection.find(@select_id)
        @items = []
        if @collection
puts("****** Get metadata for virtual collection #{@collection.title}")
          @collection.proxy_resources.each do |proxy|
            uri = proxy.proxy_for.first.rdf_subject.to_s  if proxy.proxy_for.first
            parsable_uri = URI(uri)  if uri
            metadata_callback = Ld4lVirtualCollection::Engine.configuration.find_metadata_callback(parsable_uri.host) if parsable_uri
            items_metadata = metadata_callback.call( [ uri ] )  if metadata_callback
            @items << { :proxy => proxy, :metadata => items_metadata.first, :proxy_for => uri }  if items_metadata && items_metadata.size > 0

### TODO Look for all usage of proxy_for and make sure correct.  Cause it isn't correct here.

            # @proxy_for = uri  ### TODO This isn't correct as the proxy gets reset with every loop.  How is it being used?  Should get proxy from @items.
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
