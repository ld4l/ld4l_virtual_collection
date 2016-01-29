require_dependency "ld4l_virtual_collection/application_controller"


# TODO This code implies that @collection is an instance of the Collection model, but it is actually an instance of
#      LD4L::OreRDF::Aggregation.  Should the Collection model be updated to hold the instance of LD4L::OreRDF::Aggregation
#      and have the methods updated to redirect to the Aggregation model?  OR should Collection inherit from
#      LD4L::OreRDF::Aggregation and get the methods that way?  That seems the cleaner way to go.


module Ld4lVirtualCollection
  class MyVirtualCollectionsController < ApplicationController
    before_action :set_collections, :set_page_title
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


    # # TODO XXX
    # # GET /my_virtual_collections/new_collection_items_by_query_modal/1
    # def new_collection_items_by_query_modal
    #   # puts("*** Entering CTRL: new virtual collection items by query")
    #   @item = Item.new(@collection)
    #   @proxy_for = ""
    #   respond_to do |format|
    #     format.html
    #     format.js
    #   end
    # end


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
      def set_page_title
        @heading = "Virtual Collections"
      end

      def set_collections
        @collections = []
        collections = Collection.all
Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("*** Entering CTRL: set_collections -- @collections=#{@collections}")
        collections.each do |uri, col|
          parsed_col = {}
          parsed_col[:title] = col[:title]
          parsed_col[:description] = col[:description]
          parsed_col[:uri] = uri
          parsed_col[:id] = /https?:\/\/(\w*):?(\d{4})?([\/\w]*)\/(\w{10}-\w{4}-\w{4}-\w{4}-\w{12})/.match(uri).values_at(4)
          @collections << parsed_col
        end

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
Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("*** Entering CTRL: set_collection_and_items")
Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("params=#{params}")
        @select_id  = params[:id]
        @collection = Collection.find(@select_id)
        @items = []
        if @collection
Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("****** Get metadata for virtual collection #{@collection.title}")
          @collection.proxy_resources.each do |proxy|
            next if proxy.nil?
            proxy_for = proxy.proxy_for.first if proxy.proxy_for.is_a? Array
            next if proxy_for.nil?
            uri = proxy_for if proxy_for.is_a? String
            uri = proxy_for.rdf_subject.to_s unless proxy_for.is_a? String
Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("   begin processing URI: #{uri}")
            parsable_uri = URI(uri)  if uri
            metadata_callback = Ld4lVirtualCollection::Engine.configuration.find_metadata_callback(parsable_uri.host) if parsable_uri
            metadata_callback = Ld4lVirtualCollection::Engine.configuration.get_default_metadata_callback  unless metadata_callback
            items_metadata = metadata_callback.call( [ uri ] )  if metadata_callback

            notes = Ld4lVirtualCollection::Note.all(@collection,proxy)
            note = notes.first                                         if     notes && notes.size > 0
            note = Ld4lVirtualCollection::Note.new(@collection,proxy)  unless notes && notes.size > 0

            tag_values = Ld4lVirtualCollection::Tag.all_values(proxy)
            tag = Ld4lVirtualCollection::Tag.new(@collection,proxy)

            @items << { :proxy => proxy, :metadata => items_metadata.first, :proxy_for => uri, :note => note, :tag => tag, :tags => tag_values }  if items_metadata && items_metadata.size > 0

Ld4lVirtualCollection::Engine.configuration.debug_logger.warn("   processing complete - #{@items.size} items retrieved")
### TODO Look for all usage of proxy_for and make sure correct.  Cause it isn't correct here.

            # @proxy_for = uri  ### TODO This isn't correct as the proxy gets reset with every loop.  How is it being used?  Should get proxy from @items.
          end
        end
        # TODO: Following 3 values are kludged for first page.  Need better method for calculating when multiple pages.
        @first_idx  = @items.size > 0 ? 1 : 0
        @last_idx   = @items.size <= 20 ? @items.size : 20
        @num_items  = @items.size
        @note = nil
      end

    # Only allow a trusted parameter "white list" through.
      def my_virtual_collection_params
        params[:collection]
      end
  end
end
