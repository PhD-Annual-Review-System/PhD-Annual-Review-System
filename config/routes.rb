Rails.application.routes.draw do
	root 'home#index'

  get 'student/login', to: 'student#login'
  post 'student/login', to: 'student#authenticate'
  get 'student/dashboard', to: 'student#dashboard', as: 'student_dashboard'
  get 'student/signup', to: 'student#new_signup'
  post 'student/signup', to: 'student#create_signup'
  get 'student/logout', to: 'student#logout', as: 'student_logout'
  get 'student/edit_committee', to: 'student#edit_committee', as: 'edit_committee_student'
  get 'student/search_faculty', to: 'student#search_faculty'
  post 'student/add_to_committee', to: 'student#add_to_committee' , as: 'student_add_to_committee'
  post 'student/set_as_chair/:id', to: 'student#set_as_chair', as: 'set_as_chair_student'
  post 'student/return_to_member/:id', to: 'student#return_to_member', as: 'return_to_member_student'

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
