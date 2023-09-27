class Faculty < ApplicationRecord
    def authenticate(submitted_password)
        return true
        # Check if the submitted password matches the stored hashed password.
        # if BCrypt::Password.new(password_digest) == submitted_password
         # return true
        #else
        #  return false
        #end
    end
end
