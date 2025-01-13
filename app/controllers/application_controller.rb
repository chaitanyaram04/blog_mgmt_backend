class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session, if: -> { request.format.json? }

    before_action :set_current_user
    include GetUser
    
    private

    def set_current_user
        @current_user = get_current_user
    end
end
