class Committee < ApplicationRecord
    belongs_to :student
    belongs_to :faculty
end