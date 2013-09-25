require "omniauth"
require "omniauth-bitbucket"

missing = %w(REPOSITORY BITBUCKET_CLIENT_ID BITBUCKET_CLIENT_SECRET).
  reject { |k| ENV.include? k }

unless missing.empty?
  abort "Missing from ENV: #{missing.join ', '}"
end

id     = ENV["BITBUCKET_CLIENT_ID"]
secret = ENV["BITBUCKET_CLIENT_SECRET"]
options = {:scope => "user,repo"}

if ENV['BITBUCKET_ENTERPRISE_URL']
  options.merge!({:client_options => {
    :site          => "#{ENV['BITBUCKET_ENTERPRISE_URL']}/api/v3",
    :authorize_url => "#{ENV['BITBUCKET_ENTERPRISE_URL']}/login/oauth/authorize",
    :token_url     => "#{ENV['BITBUCKET_ENTERPRISE_URL']}/login/oauth/access_token"}
  })
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bitbucket, id, secret, options
end
