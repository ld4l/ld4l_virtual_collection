Ld4lVirtualCollection::Engine.routes.draw do

  get "my_virtual_collections/new_collection_modal"  => 'my_virtual_collections#new_collection_modal',  :as => :new_collection_modal
  get "my_virtual_collections/edit_collection_modal/:id" => 'my_virtual_collections#edit_collection_modal', :as => :edit_collection_modal
  get "my_virtual_collections/new_collection_item_modal/:id"  => 'my_virtual_collections#new_collection_item_modal',  :as => :new_collection_item_modal
  resources :my_virtual_collections

  patch "item/:id/tags/" => 'tags#manage_all', :as => :item_tags
  resources :collections do
    resources :items do
      resources :notes, shallow: true
      resources :tags, shallow: true
    end
  end
end
