class Subdomain
  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      account = Account.find_by subdomain: request.subdomain
      return true if account # -> if account is not found, return false (IE no route)
    end
  end
end

Rails.application.routes.draw do

  match "/:username/profile" => "profile#index", via: :get, as: :profile
  match "/:username/update_account" => "profile#account_update", via: :put, as: :update_account
  match "/:username/update_profile" => "profile#update", via: :put, as: :profile_account
  get "/confirmation_expired" => "profile#expired_confirmations"

  # constraints(Subdomain) do

  #   devise_for :students, :skip => [:passwords], controllers: { registrations: "students/registrations", sessions: "students/sessions" }
  #   devise_scope :student do
      
  #   end

  #   authenticated :student do
  #     root 'dashboard#index', as: :student_authenticated_root
  #   end
  # end

  constraints(Subdomain) do
    %w(student teacher).each do |resource|
      resource_name = resource.pluralize
      devise_for resource_name.to_sym, :skip => [:passwords, :sessions], controllers: { registrations: "resource/registrations", confirmations: "resource/confirmations", sessions: "resource/sessions" }
      devise_scope resource.to_sym do
        get "#{resource_name}/new" => "resource/registrations#new", as: "new_#{resource}".to_sym
        delete "#{resource}/logout" => "resource/sessions#destroy", as: "destroy_#{resource}_session".to_sym
        get "#{resource_name}/login" => "resource/sessions#new", as: "#{resource_name}_login".to_sym
        get "#{resource_name}/login_after_confirmation" => "resource/sessions#login_after_confirmation", as: "#{resource_name}_login_after_confirmation".to_sym
      end

      authenticated resource.to_sym do
        root 'dashboard#index', as: "#{resource}_authenticated_root".to_sym
      end
    end
  end

  constraints :subdomain => "admin" do 
    # devise_for :admins, :skip => [:passwords, :registrations, :confirmations], controllers: { sessions: "admins/sessions" }
    devise_scope :admin do
      get "/login" => "resource/sessions#new", as: :admin_login
      delete "admins/logout" => "resource/sessions#destroy", as: :destroy_admin_session
    end

    # for student redirection after setup complete
    # get ":batch_name" => "resource/registrations#new", as: :new_admissions
    
    scope :module => 'admins' do
      # Admin Settings
      resources :settings, only: [:index] do 
        collection do
          get "/account" => "settings#admin_account", as: :admin_account
          put "/" => "settings#update", as: :update_account
          get "/week_days" => "settings#week_days_and_timings", as: :set_week_days
          get "/current_batches" => "settings#current_batches", as: :current_batches
        end
      end

      resources :admissions, only: [:index] do
        collection do 
          post "/cancel_admission" => "admissions#cancel_admission", as: :cancel
          post "/setup_admission" => "admissions#setup_admission", as: :setup
          get "/autocomplete_guardians_search" => "admissions#autocomplete_guardians_search", as: :autocomplete_guardians
          get "/get_parent/:parent_id" => "admissions#get_parent"
        end
      end

      # Admin Students
      resources :students, only: [:index] do
        get "/search" => "students#search", on: :collection, as: :search
      end

      # Admin Teachers
      resources :teachers, only: [:index, :update]do
        get "/search" => "teachers#search", on: :collection, as: :search
      end
    end

    authenticated :admin do
      root 'dashboard#index', as: :admin_authenticated_root
    end
  end


  namespace :institutes do
    resources :batches, except: [:show, :edit, :new] do
      put "/add_sections" => "batches#add_sections", as: :add_sections
    end

    get "/get_sections" => "base#get_sections", as: :get_sections

    resources :classrooms, except: [:edit]
    resources :courses do 
      get "get_course/:semester_name" => "courses#get_course_by_section", on: :collection
    end
    resources :course_allocations, only: [:index, :create, :update] do 
      get "courses" => "course_allocations#get_courses_by_batch", on: :collection
      post "allocate", on: :collection
      get ":batch_id/get_allocations" => "course_allocations#get_allocations", on: :collection, as: :get_allocations
    end
  end

  resources :dashboard, only: [:index]

  get "/about_us" => "landings#about"
  root to: "landings#home"
end
