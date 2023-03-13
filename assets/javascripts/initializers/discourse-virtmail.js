import { withPluginApi } from "discourse/lib/plugin-api";

function initializeDiscourseVirtmail(api) {
  api.addStorePluralization('address', 'addresses');
}

export default {
  name: "discourse-virtmail",

  initialize() {
    withPluginApi("0.8.31", initializeDiscourseVirtmail);
  }
};
