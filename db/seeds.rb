# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

more_student = [
  {:first_name => 'Harsh', :last_name => 'Surolia', :email_id => 'harshsurolia@tamu.edu', :password => '12345678', :UIN => 2609}
]

more_student.each do |student|
    Student.create!(student)
  end

more_faculty = [
  {:first_name => 'Prof', :last_name => 'Example', :email_id => 'profexample@tamu.edu', :password => '12345678'},
  {:first_name => 'John', :last_name => 'Doe', :email_id => 'jdtest@tamu.edu', :password => '12345678'}
]

more_faculty.each do |faculty|
    Faculty.create!(faculty)
  end
  
more_admin = [
  {:first_name => 'Admin', :last_name => 'Example', :email_id => 'adminexample@tamu.edu', :password => '12345678'}
]

more_admin.each do |admin|
    Admin.create!(admin)
  end

