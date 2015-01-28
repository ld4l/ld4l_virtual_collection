require 'test_helper'

module Ld4lVirtualCollection
  class VirtualCollectionsControllerTest < ActionController::TestCase
    setup do
      @virtual_collection = virtual_collections(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:virtual_collections)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create virtual_collection" do
      assert_difference('VirtualCollection.count') do
        post :create, virtual_collection: { description: @virtual_collection.description, title: @virtual_collection.title }
      end

      assert_redirected_to virtual_collection_path(assigns(:virtual_collection))
    end

    test "should show virtual_collection" do
      get :show, id: @virtual_collection
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @virtual_collection
      assert_response :success
    end

    test "should update virtual_collection" do
      patch :update, id: @virtual_collection, virtual_collection: { description: @virtual_collection.description, title: @virtual_collection.title }
      assert_redirected_to virtual_collection_path(assigns(:virtual_collection))
    end

    test "should destroy virtual_collection" do
      assert_difference('VirtualCollection.count', -1) do
        delete :destroy, id: @virtual_collection
      end

      assert_redirected_to virtual_collections_path
    end
  end
end
