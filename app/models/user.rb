class User < ApplicationRecord
  attr_accessor :password, :verify_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validate :passwords_match

  private

  def passwords_match
    return if password == verify_password

    errors.add(:password, 'does not match the verification password.')
  end
end
