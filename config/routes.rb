class Subdomain
  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      account = Account.find_by subdomain: request.subdomain
      return true if account # -> if account is not found, return false (IE no route)
    end
  end
end

Rails.application.routes.draw do

  constraints(Subdomain) do
    devise_for :students, controllers: { registrations: "students/registrations", sessions: "students/sessions", confirmations: "students/confirmations" }
    devise_scope :student do
      get "students/login" => "students/sessions#new", as: :students_login
      get "students/login_after_confirmation" => "students/sessions#login_after_confirmation", as: :students_login_after_confirmation
      get "students/admissions/:batch_name" => "students/registrations#new", as: :new_admissions
      post "/cancel_admission" => "students/registrations#cancel_admission"
      post "/setup_admission" => "students/registrations#setup_admission", as: :setup_admissions
      get "/autocomplete_guardians_search" => "students/registrations#autocomplete_guardians_search"
      get "/get_parent/:parent_id" => "students/registrations#get_parent"
    end
  end

  authenticated :student do
    root 'students/dashboard#index', as: :student_authenticated_root
  end

  constraints(Subdomain) do 
    devise_for :teachers, controllers: { registrations: "teachers/registrations", sessions: "teachers/sessions" }
    devise_scope :teacher do
      get "teachers/login" => "teachers/sessions#new", as: :teachers_login
      get "teachers/new" => "teachers/registrations#new", as: :new_teacher
    end
  end

  authenticated :teacher do
    root 'teachers/dashboard#index', as: :teacher_authenticated_root
  end

  # devise_for :parents

  constraints :subdomain => "admin" do 
    devise_for :admins, controllers: { sessions: "admins/sessions" }
    devise_scope :admin do
      get "/login" => "admins/sessions#new", as: :admin_login
    end
    
    scope :module => 'admins' do
      # Admin Dashboard
      resources :settings, only: [:update] do 
        collection do
          get "/account" => "settings#admin_account", as: :admin_account
          get "/week_days" => "settings#week_days_and_timings", as: :set_week_days
        end
      end

      # Admin Students
      resources :students, only: [:index] do
        get "/search" => "students#search", on: :collection, as: :search
      end

      # Admin Teachers
      resources :teachers, only: [:index]do
        get "/search" => "teachers#search", on: :collection, as: :search
      end
    end

    authenticated :admin do
      root 'admins/settings#index', as: :admin_authenticated_root
    end
  end


  namespace :institutes do
    resources :batches, only: [:index, :create, :destroy] do
      put "/add_sections" => "batches#add_sections", as: :add_sections
    end
    resources :sections, only: [:index, :update, :destroy]

    get "/get_sections" => "base#get_sections", as: :get_sections

    resources :classrooms
    resources :courses do 
      get "get_course/:semester_name" => "courses#get_course_by_section", on: :collection
    end
    resources :course_allocations, only: [:index, :create, :update] do 
      get "get_allocation_record" => "course_allocations#get_allocation_record", on: :collection
    end
  end

  get "/about_us" => "landings#about"
  root to: "landings#home"
  
end
