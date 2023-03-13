import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default {
  @action
  resetVirtmailPassword(model) {
    ajax(
      `/discourse-virtmail/u/${this.get("model.username_lower")}/reset_password`,
      { type: "POST" }
    )
    .then((json) => {
      this.model.set("virtmail_password", json.password);
    })
    .catch(popupAjaxError);
  },
};
