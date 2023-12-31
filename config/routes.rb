Rails.application.routes.draw do
  resources :student_documents
	root 'home#index'

  get 'student/login', to: 'student#login'
  post 'student/login', to: 'student#authenticate'
 
  get 'student_documents', to: 'student_documents#index'
  patch 'student_documents', to: 'student_documents#update'

  get 'student/signup', to: 'student#new_signup'
  post 'student/signup', to: 'student#create_signup'
  get 'student/dashboard', to: 'student#dashboard', as: 'student_dashboard'
  get 'student/logout', to: 'student#logout', as: 'student_logout'
  get 'student/edit_committee', to: 'student#edit_committee', as: 'edit_committee_student'
  get 'student/search_faculty', to: 'student#search_faculty', as: 'search_faculty_student'
  post 'student/add_to_committee', to: 'student#add_to_committee' , as: 'student_add_to_committee'
  post 'student/set_as_chair/:id', to: 'student#set_as_chair', as: 'set_as_chair_student'
  post 'student/return_to_member/:id', to: 'student#return_to_member', as: 'return_to_member_student'
  get 'student/assessments/:id', to: 'student#view_assessments', as: 'student_view_assessments'
  get 'student/change_password', to: 'student#change_password', as: 'change_password_student'
  patch 'student/update_password', to: 'student#update_password', as: 'update_password_student'
  get 'student/view_submission/', to: 'student#view_submission', as: 'student_view_submission'


  get 'admin/login', to: 'admin#login'
  post 'admin/login', to: 'admin#authenticate'
  get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'
  get 'admin/logout', to: 'admin#logout', as: 'admin_logout'

  get 'faculty/login', to: 'faculty#login'
  post 'faculty/login', to: 'faculty#authenticate'
  get 'faculty/dashboard', to: 'faculty#dashboard', as: 'faculty_dashboard'
  get 'faculty/review_student/:id', to: 'faculty#review_student', as: 'faculty_review_student'

  #post 'faculty/save_assessment', to: 'faculty#save_assessment', as: 'faculty_save_assessment'
  post 'faculty/save_assessment', to: 'faculty#save_assessment', as: 'faculty_save_assessment'
  get 'faculty/save_assessment', to: 'faculty#save_assessment' # Optional: Only if you need a GET request here


  get 'faculty/view_assessment/:id', to: 'faculty#view_assessment', as: 'faculty_view_assessment'
  get 'faculty/change_password', to: 'faculty#change_password', as: 'change_password_faculty'
  patch 'faculty/update_password', to: 'faculty#update_password', as: 'update_password_faculty'


  get 'document/new'
  get 'document/create'
  get 'faculty/logout', to: 'faculty#logout', as: 'faculty_logout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Defines the root path route ("/")
  # root "articles#index"
end
