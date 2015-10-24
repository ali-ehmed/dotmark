Rails.application.routes.draw do
  devise_for :admins


  namespace :institutes do
    resources :batches, only: [:index, :create, :destroy] do
      put "/add_sections" => "batches#add_sections", as: :add_sections
    end
    resources :sections, only: [:index, :update, :destroy] do
      get "/get_sections" => "sections#get_sections", as: :get_sections, on: :collection
    end

    resources :classrooms, only: [:index, :create, :update, :destroy]
  end

  authenticated :admin do
    root 'landing#dashboard', as: :authenticated_root
  end

  unauthenticated :admin do
    devise_scope :admin do 
      get "/", to: "devise/sessions#new"
    end
  end
  
end
