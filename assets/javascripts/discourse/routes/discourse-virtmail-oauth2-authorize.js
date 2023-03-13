import { action } from "@ember/object";
import DiscourseRoute from 'discourse/routes/discourse'

export default DiscourseRoute.extend({
  controllerName: "oauth2-authorize",

  renderTemplate() {
    this.render("oauth2-authorize");
  },

});
