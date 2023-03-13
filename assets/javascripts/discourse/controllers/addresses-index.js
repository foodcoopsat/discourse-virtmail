import { action } from "@ember/object";
import Controller from "@ember/controller";
import I18n from "I18n";
import bootbox from "bootbox";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Controller.extend({
  addresses: {
  },

  @action
  resetPassword(address) {
    address.resetPassword();
  },

  @action
  destroy(address) {
    return bootbox.confirm(
      I18n.t("discourse-virtmail.addresses.delete_confirm"),
      I18n.t("no_value"),
      I18n.t("yes_value"),
      (result) => {
        if (result) {
          address
            .destroyRecord()
            .then(() => {
              this.model.removeObject(address);
            })
            .catch(popupAjaxError);
        }
      }
    );
  },
});
