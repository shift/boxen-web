Boxen::Application.routes.draw do
  root :to => "Splash#index"
  get "/auth/bitbucket/callback" => "Auth#create"
  get "/logout" => "Auth#destroy"

  get "/script/:token.sh" => "Splash#script"
end
