class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    return nil unless user

    # if user.admin?
    #   return errors.add(:user_authentication, I18n.t('errors.messages.access_denied'))
    # end

    user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by(email: email)
    if user&.valid_password?(password)

      user.update(authentication_token: generate_token)
      return user
    end

    errors.add(:user_authentication, I18n.t('errors.messages.authenticate_fail'))
    nil
  end

  def generate_token
    token = nil
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).exists?
    end
    token
  end
end
