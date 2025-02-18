module DiscourseVirtmail
  class AddressesController < ::ApplicationController
    requires_plugin DiscourseVirtmail::PLUGIN_NAME


    before_action :ensure_logged_in

    def index
      rows = store_rows.order(:key)
      render json: { addresses: serialize_data(rows, AddressSerializer) }
    end

    def authorize
      rows = PluginStoreRow
        .where(plugin_name: 'virtmail')
        .where("value::jsonb->'allowed_users' @> '?'", current_user.id)
        .order(:key)
      render json: { addresses: serialize_data(rows, AuthorizeAddressSerializer) }
    end

    def show
      row = store_rows.find(params[:id])
      row.reload
      render_serialized(row, AddressSerializer)
    end

    def create
      address = address_params
      allowed_users = find_users(address[:allowed_users])

      row = PluginStoreRow.create!({
        plugin_name: 'virtmail',
        key: "#{address[:domain]}@#{address[:localpart]}",
        type_name: 'JSON',
        value: {
          comment: address[:comment] || "",
          destinations: address[:destinations] || [],
          forward_only: address[:forward_only] || false,
          quota_bytes: address[:quota_bytes] || 0,
          allowed_users: allowed_users || [],
        }.to_json
      })

      render_serialized(row, AddressSerializer)
    end

    def update
      address = address_params
      row = store_rows.find(params[:id])
      value = JSON.parse(row.value)

      value["comment"] = address[:comment] || ""
      value["destinations"] = address[:destinations] || []
      value["forward_only"] = address[:forward_only] || false
      value["quota_bytes"] = address[:quota_bytes] || 0
      value["allowed_users"] = find_users(address[:allowed_users]) || []

      row.update!({
        key: "#{address[:domain]}@#{address[:localpart]}",
        value: value.to_json
      })
      row.reload

      render_serialized(row, AddressSerializer)
    end

    def reset_password
      row = store_rows.find(params[:id])
      value = JSON.parse(row.value)

      password = SecureRandom.hex
      value["password"] = "{SHA512-CRYPT}#{password.crypt("$6$#{SecureRandom.base64}")}"

      row.update!(value: value.to_json)

      render json: { password: password }
    end

    def destroy
      store_rows.find(params[:id]).destroy
      render json: success_json
    end

    def domains
      render json: { domains: current_user.allowed_virtmail_domains }
    end

    private

    def store_rows
      PluginStoreRow.where("plugin_name = ? AND key LIKE ANY(ARRAY[?])", 'virtmail', key_likes)
    end

    def key_likes
      return ['%'] if current_user.admin?

      current_user.allowed_virtmail_domains.map { |domain| "#{domain}@%" }
    end

    def find_users(usernames)
      return unless usernames
      User.where(username: usernames).pluck(:id)
    end

    def address_params
      ret = params
        .require(:address)
        .permit(:domain, :localpart, :comment, :quota_bytes, :forward_only, destinations: [], allowed_users: [])

      raise Discourse::InvalidParameters.new(:domain) unless current_user.allowed_virtmail_domains.include?(ret[:domain])

      ret
    end
  end
end
