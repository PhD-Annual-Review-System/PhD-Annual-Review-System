class StudentDocument < ApplicationRecord
  belongs_to :student, optional: true
  
end
