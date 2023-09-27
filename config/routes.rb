Rails.application.routes.draw do
  resources :student_documents
	root 'home#index'

  get 'student/login', to: 'student#login'
  post 'student/login', to: 'student#authenticate'
  get 'student/dashboard', to: 'student_documents#index', as: 'student_dashboard'
  get 'student/signup', to: 'student#new_signup'
  post 'student/signup', to: 'student#create_signup'

  get 'admin/login', to: 'admin#login'
  post 'admin/login', to: 'admin#authenticate'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'

  get 'faculty/login', to: 'faculty#login'
  post 'faculty/login', to: 'faculty#authenticate'
  get 'faculty/dashboard', to: 'faculty#dashboard', as: 'faculty_dashboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
