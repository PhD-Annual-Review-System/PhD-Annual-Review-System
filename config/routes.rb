Rails.application.routes.draw do
  resources :student_documents
	root 'home#index'

  get 'student/login', to: 'student#login'
  post 'student/login', to: 'student#authenticate'
 
  get 'student/documents', to: 'student_documents#index'
  patch 'student_documents', to: 'student_documents#update'
  post 'student/documents', to: 'student_documents#create'

  get 'student/signup', to: 'student#new_signup'
  post 'student/signup', to: 'student#create_signup'
  get 'student/logout', to: 'student#logout', as: 'student_logout'

  get 'admin/login', to: 'admin#login'
  post 'admin/login', to: 'admin#authenticate'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'
  get 'admin/logout', to: 'admin#logout', as: 'admin_logout'

  get 'faculty/login', to: 'faculty#login'
  post 'faculty/login', to: 'faculty#authenticate'
  get 'faculty/dashboard', to: 'faculty#dashboard', as: 'faculty_dashboard'
  get 'faculty/logout', to: 'faculty#logout', as: 'faculty_logout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
