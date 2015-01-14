require 'test_helper'

module Ld4lVirtualCollection
  class MyVirtualCollectionsControllerTest < ActionController::TestCase
    setup do
      @my_virtual_collection = my_virtual_collections(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:my_virtual_collections)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create my_virtual_collection" do
      assert_difference('MyVirtualCollection.count') do
        post :create, my_virtual_collection: {  }
      end

      assert_redirected_to my_virtual_collection_path(assigns(:my_virtual_collection))
    end

    test "should show my_virtual_collection" do
      get :show, id: @my_virtual_collection
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @my_virtual_collection
      assert_response :success
    end

    test "should update my_virtual_collection" do
      patch :update, id: @my_virtual_collection, my_virtual_collection: {  }
      assert_redirected_to my_virtual_collection_path(assigns(:my_virtual_collection))
    end

    test "should destroy my_virtual_collection" do
      assert_difference('MyVirtualCollection.count', -1) do
        delete :destroy, id: @my_virtual_collection
      end

      assert_redirected_to my_virtual_collections_path
    end
  end
end
