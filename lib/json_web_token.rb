class JsonWebToken
  class << self

    SECRET_KEY = Rails.application.secrets.secret_key_base. to_s

    def authenticate(token, sub = :auth)
      decoded_auth_payload = decode(token, sub)
      user ||= User.find_by(id: decoded_auth_payload[:user_id]) if decoded_auth_payload
      return user if is_authenticated?(user, sub, decoded_auth_payload)

      # Return nil if the user could not be authenticated
      nil
    end

    def generate_token(user, sub = :auth, exp = 24.to_i.hours.from_now)
      payload = { user_id: user.id,
                  signature: user.send("#{sub.to_s}_token"),
                  sub: sub.to_s,
                  exp: exp.to_i }

      encode(payload)
    end

    private

    def encode(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token, sub)
      claims = { sub: sub.to_s, verify_sub: true }
      key = Rails.application.secret_key_base

      body = JWT.decode(token, key, true, claims)[0]

      HashWithIndifferentAccess.new body
    rescue StandardError => e
      # Return nil if token is invalid
      nil
    end

    def is_authenticated?(user, sub, decoded_payload)
      user && decoded_payload && \
        decoded_payload[:signature] && \
        (token = user.send("#{sub.to_s}_token")) && \
        ActiveSupport::SecurityUtils.secure_compare(token, decoded_payload[:signature])
    end
  end
end
