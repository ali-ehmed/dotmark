Rails.application.routes.draw do
  devise_for :admins


  namespace :institutes do
    resources :batches, only: [:index, :create, :destroy]
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
