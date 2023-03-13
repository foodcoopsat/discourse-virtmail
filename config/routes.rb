require_dependency "discourse_virtmail_constraint"

DiscourseVirtmail::Engine.routes.draw do
  get "/oauth2/authorize" => "addresses#authorize", constraints: DiscourseVirtmailConstraint.new
  post "/oauth2/authorize" => "oauth2#authorize", constraints: DiscourseVirtmailConstraint.new
  post "/oauth2/token" => "oauth2#token", constraints: DiscourseVirtmailConstraint.new
  post "/oauth2/introspect" => "oauth2#introspect", constraints: DiscourseVirtmailConstraint.new
  get "/oauth2/introspect" => "oauth2#introspect", constraints: DiscourseVirtmailConstraint.new

  post "/u/:username/reset_password" => "user#reset_password", constraints: { username: RouteFormat.username }

  resources :addresses, constraints: DiscourseVirtmailConstraint.new do
    collection do
      get "/domains" => "addresses#domains", constraints: DiscourseVirtmailConstraint.new
    end

    member do
      post "/reset_password" => "addresses#reset_password", constraints: DiscourseVirtmailConstraint.new
    end
  end
end
