# spec/factories/assessments.rb

FactoryBot.define do
    factory :assessment do
      student { association :student } # Assumes you have a student factory defined
      faculty { association :faculty } # Assumes you have a faculty factory defined
      public_comment { 'Good work' }
      rating { 'Satisfactory' }
      eligible_for_reward { true }
    end
  end
  