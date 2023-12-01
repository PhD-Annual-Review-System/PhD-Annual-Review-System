require 'csv'

namespace :db do
  desc 'Populate the database with student, faculty, and admin data from CSV files'
  task populate: :environment do
    # Populate students
    csv_path_students = Rails.root.join('resources', 'students.csv')
    CSV.foreach(csv_path_students, headers: true) do |row|
      Student.create!(row.to_hash)
    end

    # Populate faculties
    csv_path_faculties = Rails.root.join('resources', 'faculties.csv')
    CSV.foreach(csv_path_faculties, headers: true) do |row|
      Faculty.create!(row.to_hash)
    end

    # Populate admins
    csv_path_admins = Rails.root.join('resources', 'admins.csv')
    CSV.foreach(csv_path_admins, headers: true) do |row|
      Admin.create!(row.to_hash)
    end

    puts 'Database populated successfully.'
  end
end
