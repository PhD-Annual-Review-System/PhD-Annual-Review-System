FactoryBot.define do
    factory :committee do
      association :student
      association :faculty
      role { 'Member' }
    end
  end