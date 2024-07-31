Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  root 'employees#home'

  get 'login', to: 'employees#login'
  post 'login', to: 'employees#login'
  get "/logout", to: "employees#logout"
  get 'signup', to: 'employees#signup', as: 'signup'
  post '/signup', to: 'employees#create'
  get 'admin_dashboard', to: 'employees#admin_dashboard', as: 'admin_dashboard'


  resources :employees, only: [:new, :show] do
    member do
      get 'upload'
    end
  end
  resources :admins, only: [:new, :create, :index, :show]

  resources :attendences, only: [] do
    collection do
      post :upload
    end
  end
end
