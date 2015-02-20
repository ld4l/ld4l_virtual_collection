require_dependency "ld4l_virtual_collection/application_controller"

module Ld4lVirtualCollection
  class NotesController < ApplicationController
    before_action :set_collection_and_item, only: [:new, :create, :index]
    before_action :set_note, only: [:show, :edit, :update, :destroy]

    # GET /collections/1/items/1/notes
    def index
      @notes = Note.all(@collection,@item)
    end

    # GET /notes/1
    def show
    end

    # GET /collections/1/items/1/notes/new
    def new
      # puts("*** Entering CTRL: new note")
      @note = Note.new(@collection,@item)
    end

    # GET /notes/1/edit
    def edit
      # puts("*** Entering CTRL: edit note")
    end

    # POST /collections/1/items/1/notes
    def create
      # puts("*** Entering CTRL: create note")
      @note = Note.new(@collection, @item, note_params)

      if @note.persist! == true
        redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Note was successfully created.'
      else
        # TODO How to add error message about what failed to persist???
        render :new
      end
    end

    # PATCH/PUT /notes/1
    def update
      # puts("*** Entering CTRL: update note")
      @note = Note.update(@note, note_params)
      # TODO should check old and new values and only update if changed
      # TODO How to save only affected items & collection instead of all items & collection???
      if @note.persist! == true
        redirect_to my_virtual_collection_path(note_params[:collection_id]), notice: 'Note was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /notes/1
    def destroy
      # puts("*** Entering CTRL: destroy note")
      @note.destroy
      # if LD4L::OreRDF::DestroyProxy.call(@collection,@item.rdf_subject) == true
      redirect_to my_virtual_collection_path(@collection.id.to_s), notice: 'Note was successfully removed.'
      # else
      #   # TODO Should it redirect to edit???  OR list???  OR  where???
      #   # TODO How to add error message about what failed to be destroyed???
      #  render :edit
      # end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_note
        @note = Note.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def note_params
        params[:note]
      end

      def set_collection_and_item
        @collection = Collection.find(params["collection_id"])
        @item = Item.find(params["item_id"])
        @proxy_for = @item && @item.proxy_for && @item.proxy_for.first ? @item.proxy_for.first.rdf_subject : ""
      end
  end
end
