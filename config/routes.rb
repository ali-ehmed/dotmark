Rails.application.routes.draw do
  devise_for :admins
	get "/settings" => "admins#settings"

  authenticated :admin do
    root 'landing#dashboard', as: :authenticated_root
  end

  unauthenticated :admin do
    devise_scope :admin do 
      get "/", to: "devise/sessions#new"
    end
  end
  
end
