Rails.application.routes.draw do
  devise_for :students, controllers: { registrations: "students/registrations" }
  devise_scope :student do
    get "students/admissions/:batch_name" => "students/registrations#new", as: :new_admissions
    post "/cancel_admission" => "students/registrations#cancel_admission"
    post "/setup_admission" => "students/registrations#setup_admission", as: :setup_admissions
    get "/autocomplete_guardians_search" => "students/registrations#autocomplete_guardians_search"
    get "/get_parent/:parent_id" => "students/registrations#get_parent"
  end
  resources :students, only: [:index]

  devise_for :parents
  devise_for :admins


  namespace :institutes do
    resources :batches, only: [:index, :create, :destroy] do
      put "/add_sections" => "batches#add_sections", as: :add_sections
    end
    resources :sections, only: [:index, :update, :destroy]

    get "/get_sections" => "base#get_sections", as: :get_sections

    resources :classrooms
    resources :courses
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
