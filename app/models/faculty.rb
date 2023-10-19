class Faculty < ApplicationRecord
    has_secure_password

    # Associations
    has_many :committees
    has_many :students, through: :committees
    has_many :assessments

    # Validations
    validates :password, length: { minimum: 8 }, allow_blank: true
    validate :email_id_format

    def email_id_format
        if email_id.present? && !email_id.ends_with?('@tamu.edu')
          errors.add(:email_id, 'must end with @tamu.edu')
        end
      end
end
