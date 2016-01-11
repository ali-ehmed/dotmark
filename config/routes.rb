Rails.application.routes.draw do
  get 'time_table/index'

  # Routes for Students and Teachers
  constraints(Subdomain) do
    resources :profiles, :path => ":username", only: [:index] do
      collection do
        get "/settings" => "profiles#edit", as: :edit
        put "settings/security" => "profiles#security", as: :security
        put "settings/profile" => "profiles#update", as: :profile
      end
    end

    %w(student teacher).each do |resource|
      resource_name = resource.pluralize
      devise_for resource_name.to_sym, :skip => [:passwords, :registrations], controllers: { confirmations: "resources/confirmations", sessions: "resources/sessions" }
      devise_scope resource.to_sym do
        get "#{resource_name}/login" => "resources/sessions#new", as: "#{resource_name}_login".to_sym
        get "#{resource_name}/login_after_confirmation" => "resources/sessions#login_after_confirmation", as: "#{resource_name}_login_after_confirmation".to_sym
      end

      authenticated resource.to_sym do
        root 'dashboard#index', as: "#{resource}_authenticated_root".to_sym
      end
    end
  end

  # Routes for Admin
  constraints :subdomain => "admin" do 
    devise_for :admins, :skip => [:passwords, :registrations, :confirmations], controllers: { sessions: "resources/sessions" }
    devise_scope :admin do
      get "admin/login" => "resources/sessions#new", as: :admins_login
    end

    %w(student teacher).each do |resource|
      devise_for resource.pluralize.to_sym, :skip => [:passwords, :confirmations, :sessions], controllers: { registrations: "resources/registrations" }
      devise_scope resource.to_sym do
        if resource == "student"
          get "#{resource.pluralize}/admissions/:batch_name" => "resources/registrations#new", as: "new_#{resource}".to_sym
        else
          get "#{resource.pluralize}/new" => "resources/registrations#new", as: "new_#{resource}".to_sym
        end
      end
    end
    
    scope :module => 'administrations' do
      # Admin Settings
      resources :settings, :path => "admin/settings", only: [:index] do 
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
      resources :students, path: "students", only: [:index] do
        get "/search" => "students#search", on: :collection, as: :search
      end

      # Admin Teachers
      resources :teachers, path: "teachers", only: [:index, :update] do
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
      collection do
        post "allocate"
        get ":batch_id/get_allocations" => "course_allocations#get_allocations", as: :get_allocations
        delete ":batch_id/remove_allocations" => "course_allocations#remove_allocations", as: :remove_allocations
        get ":batch_id/courses_and_sections"=> "course_allocations#courses_and_sections", as: :courses_and_sections
        delete ":teacher_id/remove_teacher_allocations"=> "course_allocations#remove_teacher_allocations", as: :remove_teacher_allocations
        get "/notify_teacher_for_approval" => "course_allocations#notify_teacher_for_approval", as: :notify_teacher
      end
    end
  end

  resources :dashboard, only: [:index]

  get "/about_us" => "landings#about"
  root to: "landings#home"
end
