class User < ApplicationRecord
  has_many :articles

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def as_json_response(token)
    {
      email:,
      token:,
      username:,
      bio: nil,
      image: nil
    }
  end
end
