module GetUser
    include JwtHelper
    def get_current_user
        token = request.headers['Authorization']&.split(' ')&.last
        Rails.logger.debug "Decoded JWT payload t: #{token.inspect}"

        return nil if token.nil?
      
        decoded = decode(token) 
        Rails.logger.debug "Decoded JWT payload: #{decoded.inspect}"

        return nil if decoded.nil?
        id = decoded['user_id']
        Rails.logger.debug "Decoded JWT payload method: #{decoded.inspect}"
        User.find_by(id: id)
    end
end