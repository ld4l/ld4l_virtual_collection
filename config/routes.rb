Ld4lVirtualCollection::Engine.routes.draw do
  resources :collections do
    resources :items
  end
end
