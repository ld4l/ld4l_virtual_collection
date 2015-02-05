Ld4lVirtualCollection::Engine.routes.draw do

  get "my_virtual_collections/new_collection_modal"  => 'my_virtual_collections#new_collection_modal',  :as => :new_collection_modal
  get "my_virtual_collections/edit_collection_modal/:id" => 'my_virtual_collections#edit_collection_modal', :as => :edit_collection_modal
  resources :my_virtual_collections

  resources :collections do
    resources :items

  end
end
