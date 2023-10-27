class Assessment < ApplicationRecord
    belongs_to :student
    belongs_to :faculty

    validates :rating, presence: true
end
