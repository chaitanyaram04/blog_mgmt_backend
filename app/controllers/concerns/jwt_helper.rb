require_relative '../../../config/initializers/application_constants'

module JwtHelper
  include ApplicationConstants

    def encode(payload)
      JWT.encode(payload, ApplicationConstants::JWT_SECRET, ApplicationConstants::ALGO_TECH)
    end
  
    def decode(token)
      begin
        JWT.decode(token, ApplicationConstants::JWT_SECRET, true, { algorithm: ApplicationConstants::ALGO_TECH}).first
      rescue JWT::DecodeError
        nil
      end
    end
  end
  