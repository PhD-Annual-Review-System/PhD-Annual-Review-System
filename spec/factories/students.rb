FactoryBot.define do
    factory :student do
      first_name {'test'}
      last_name {'test'}
      UIN {12345}
      email_id { 'test1@tamu.edu' }
      password { 'password' }
      password_confirmation { 'password' }
      # Other attributes
    end
  end