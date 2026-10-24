import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'group-custom-field',
  initialize() {
    withPluginApi('2026.8', api => {
      // Add virtmail_domains as a save property for the group model
      // This will be automatically included in the JSON when saving
      api.addModelSaveProperty('group', 'virtmail_domains', function() {
        return this.custom_fields?.virtmail_domains || [];
      });
    });
  }
}
