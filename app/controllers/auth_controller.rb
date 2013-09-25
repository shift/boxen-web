class AuthController < ApplicationController
  skip_before_filter :auth, :only => :create

  def create
    if access?
      user = User.where(
        :bitbucket_id => auth_hash['uid'],
        :login => auth_hash['info']['nickname']
      ).first_or_create

      user.access_token = auth_hash.credentials['token']
      user.save

      session[:bitbucket_user_id] = auth_hash['uid']
      redirect_to session.delete(:return_to)
    else
      render :status => :forbidden, :text => "Forbidden"
    end
  end

  def destroy
    session.clear
    redirect_to (ENV['BITBUCKET_ENTERPRISE_URL'] || "https://bitbucket.com")
  end

  protected

  def bitbucket_api_url
    ghe_url = ENV['BITBUCKET_ENTERPRISE_URL']
    ghe_url ? "#{ghe_url}/api/v3" : "https://api.bitbucket.com"
  end

  def auth_hash
    env['omniauth.auth']
  end

  def access?
    (check_team_access? && team_access?) ||
    (check_user_access? && user_access?) ||
    (!check_team_access? && !check_user_access?)
  end

  def check_team_access?
    !ENV['BITBUCKET_TEAM_ID'].nil?
  end

  def team_access?
    host   = bitbucket_api_url
    path   = "/teams/#{ENV['BITBUCKET_TEAM_ID']}/members"
    params = "access_token=#{auth_hash.credentials['token']}"
    uri    = URI.parse("#{host}#{path}?#{params}")

    http         = Net::HTTP.new(uri.host, uri.port)
    request      = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
    http.use_ssl = true

    team_members = JSON.parse(http.request(request).body)

    team_members.any? do |user_hash|
      user_hash['login'] == auth_hash['info']['nickname']
    end
  end

  def check_user_access?
    !ENV['BITBUCKET_LOGIN'].nil?
  end

  def user_access?
    ENV['BITBUCKET_LOGIN'] == auth_hash['info']['nickname']
  end
end
