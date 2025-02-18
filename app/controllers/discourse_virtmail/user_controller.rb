module DiscourseVirtmail
  class UserController < ::ApplicationController
    requires_plugin DiscourseVirtmail::PLUGIN_NAME

    def reset_password
      user = fetch_user_from_params
      guardian.ensure_can_edit!(user)

      password = SecureRandom.hex
      user.custom_fields['virtmail_password'] = "{SHA512-CRYPT}#{password.crypt("$6$#{SecureRandom.base64}")}"
      user.save_custom_fields

      render json: { password: password }
    end
  end
end
