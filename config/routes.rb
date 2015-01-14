Ld4lVirtualCollection::Engine.routes.draw do
  resources :items

  resources :collections do
    resources :items
  end
end
