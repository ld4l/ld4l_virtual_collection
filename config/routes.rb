Ld4lVirtualCollection::Engine.routes.draw do

  resources :my_virtual_collections

  resources :collections do
    resources :items
  end
end
