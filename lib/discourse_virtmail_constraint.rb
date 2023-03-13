class DiscourseVirtmailConstraint
  def matches?(request)
    SiteSetting.discourse_virtmail_enabled
  end
end
