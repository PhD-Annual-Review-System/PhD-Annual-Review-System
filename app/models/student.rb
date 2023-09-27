class Student < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :UIN, presence: true
    validates :email_id, presence: true, uniqueness: true
    validates :password, presence: true
    validates_confirmation_of :password
    attr_accessor :password_confirmation

    validate :email_id_format
    
    def authenticate(submitted_password)
        return true
        # Check if the submitted password matches the stored hashed password.
        # if BCrypt::Password.new(password_digest) == submitted_password
        #  return true
        # else
        #  return false
        # end
    end

    def email_id_format
        if email_id.present? && !email_id.ends_with?('@tamu.edu')
          errors.add(:email_id, 'must end with @tamu.edu')
        end
      end

end