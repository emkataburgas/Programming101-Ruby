class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true
  validates :e_mail, presence: true, format: { with: /\A(\d*\w*)@(abv|gmail|hotmail|yahoo)\.(com|bg|org)/, message: "enter a valid e-mail"}

  def remember
    update! remember_digest: SecureRandom.urlsafe_base64

  end

  def forget
    update! remember_digest: nil
  end
end