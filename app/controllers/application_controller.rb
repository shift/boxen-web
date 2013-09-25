class ApplicationController < ActionController::Base
  before_filter :auth
  protect_from_forgery

  def current_user
    if session[:bitbucket_user_id]
      User.where(:bitbucket_id => session[:bitbucket_user_id]).first
    end
  end

  private

  def auth
    unless session[:bitbucket_user_id]
      session[:return_to] = request.path
      redirect_to "/auth/bitbucket"
    end
  end
end
