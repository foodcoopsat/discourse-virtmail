# frozen_string_literal: true

# name: discourse-virtmail
# about: Virtual E-Mail
# version: 0.1
# authors: paroga
# url: https://github.com/foodcoopsat/discourse-virtmail

enabled_site_setting :discourse_virtmail_enabled

PLUGIN_NAME ||= 'discourse-virtmail'

load File.expand_path('lib/discourse-virtmail/engine.rb', __dir__)

after_initialize do
  module ::DiscourseVirtmail
    PLUGIN_NAME ||= 'discourse-virtmail'.freeze
    GROUP_CUSTOM_FIELD_DOMAINS ||= 'virtmail_domains'.freeze
  end

  register_editable_group_custom_field({ DiscourseVirtmail::GROUP_CUSTOM_FIELD_DOMAINS => [] })

  register_group_custom_field_type(DiscourseVirtmail::GROUP_CUSTOM_FIELD_DOMAINS, [:string])

  add_to_serializer(:basic_group, :virtmail_domains) do
    object.custom_fields[DiscourseVirtmail::GROUP_CUSTOM_FIELD_DOMAINS] || []
  end

  add_to_class(:user, :allowed_virtmail_domains) do
    group_ids = self.admin? ? Group.all.pluck(:id) : self.group_users.where(owner: true).pluck(:group_id)
    Group
      .custom_fields_for_ids(group_ids, DiscourseVirtmail::GROUP_CUSTOM_FIELD_DOMAINS)
      .values
      .map { |domain| domain[DiscourseVirtmail::GROUP_CUSTOM_FIELD_DOMAINS] }
      .flatten
  end
end
