FactoryBot.define do
    factory :faculty do
      first_name {'test'}
      last_name {'test'}
      email_id { 'test1@tamu.edu' }
      password { 'password' }
      password_confirmation { 'password' }
      # Other attributes
    end
  end