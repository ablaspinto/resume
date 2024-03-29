class SignupController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    user = User,new(user_params)
    if user.save
      payload = {'user_id' : user.id}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      token = session.login
      response.set_cookie(JWTSessions.access_cookie, value: token[:access], httponly: true, secure: Rails.end.production?)
      render json: {csrf: tokens[:csrf]}
    else 
      render json: {error: user.errors.full_messages.join(' ')} , status: :uproccessable_entity
    end
  end

  private 
    def user_params
      params.permit(:email, :password , :password_confirmation)
    end

end
