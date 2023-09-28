class Student < ApplicationRecord
    has_secure_password
    
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :UIN, presence: true
    validates :email_id, presence: true, uniqueness: true
    validates :password, presence: true
    validates_confirmation_of :password
    attr_accessor :password_confirmation

    validate :email_id_format
    validates :password, length: { minimum: 8 }, allow_blank: true

    def email_id_format
        if email_id.present? && !email_id.ends_with?('@tamu.edu')
          errors.add(:email_id, 'must end with @tamu.edu')
        end
      end
end
