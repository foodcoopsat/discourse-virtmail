import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class VirtmailPassword {
  @action
  resetVirtmailPassword(model) {
    ajax(
      `/discourse-virtmail/u/${model.username_lower}/reset_password`,
      { type: "POST" }
    )
    .then((json) => {
      model.virtmail_password = json.password;
    })
    .catch(popupAjaxError);
  }
}
