class User < ApplicationRecord
  attr_accessor :password, :verify_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, if: :validate_password?
  validate :passwords_match, if: :validate_password?

  private

  def passwords_match
    return if password == verify_password

    errors.add(:password, 'does not match the verification password.')
  end

  def validate_password?
    new_record? || password.present?
  end
end
