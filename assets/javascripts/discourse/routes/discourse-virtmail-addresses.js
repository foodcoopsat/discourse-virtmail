import { action } from "@ember/object";
import DiscourseRoute from 'discourse/routes/discourse'

export default DiscourseRoute.extend({
  controllerName: "addresses",

  renderTemplate() {
    this.render("addresses");
  },

  @action
  show(address) {
    this.transitionTo("discourse-virtmail.addresses.show", address.id);
  },

  @action
  new() {
    this.transitionTo("discourse-virtmail.addresses.new");
  },
});
