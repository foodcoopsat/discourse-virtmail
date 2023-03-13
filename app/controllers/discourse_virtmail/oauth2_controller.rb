module DiscourseVirtmail
  class Oauth2Controller < ::ApplicationController
    requires_plugin DiscourseVirtmail

    # TODO implement better security checks
    skip_before_action :check_xhr, :preload_json, :redirect_to_login_if_required
    before_action :ensure_logged_in, except: [:token, :introspect]
    skip_forgery_protection

    def handle_unverified_request
    end

    def authorize
      email = params["email"]
      search = Rack::Utils.parse_nested_query(params["search"])
      code = SecureRandom.base64(12).tr('/+', '_-')

      local, domain = email&.split("@", 2)
      allowed = PluginStoreRow
        .where(plugin_name: 'virtmail', key: "#{domain}@#{local}")
        .where("value::jsonb->'allowed_users' @> '?'", current_user.id)
        .any?

      unless allowed
        render_json_dump({ error: "Adresse nicht erlaubt" }, status: 403)
        return
      end

      data = { email: email, username: email, aud: search["client_id"] }
      Discourse.redis.setex redis_key_code(code), 10.minutes, data.to_json

      query = { code: code, state: search["state"] }
      location = "#{search["redirect_uri"]}?#{query.to_query}"
      render_json_dump({ location: location })
    end

    def token
      code = params["code"]
      data = Discourse.redis.get(redis_key_code(code))
      unless data
        render_json_dump({ error: "invalid_grant" }, status: 403)
        return
      end

      Discourse.redis.del redis_key_code(code)

      token = SecureRandom.base64(12).tr('/+', '_-')
      Discourse.redis.setex redis_key_token(token), 10.minutes, data
      render_json_dump({ access_token: token, token_type: "Bearer" })
    end

    def base64url(data)
      Base64.urlsafe_encode64(data, false)
    end

    def introspect
      type, value = request.headers["HTTP_AUTHORIZATION"]&.split(" ", 2)

      unless type == "Bearer"
        render_json_dump({ error: "invalid_grant" }, status: 401)
        return
      end

      token = value
      key = redis_key_token(token)
      data = Discourse.redis.get(key)
      unless data
        render_json_dump({ error: "invalid_grant" }, status: 403)
        return
      end

      render_json_dump(ActiveSupport::JSON.decode(data))
    end

    def redis_key_token(token)
      redis_key("token", token)
    end

    def redis_key_code(code)
      redis_key("code", code)
    end

    def redis_key(prefix, key)
      "virtmail_oauth2_#{prefix}_#{key}"
    end
  end
end
