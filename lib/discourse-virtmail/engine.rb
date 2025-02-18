module DiscourseVirtmail
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseVirtmail

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::DiscourseVirtmail::Engine, at: "/discourse-virtmail"
      end
    end
  end
end
