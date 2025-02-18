import Controller from "@ember/controller";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { tracked } from "@glimmer/tracking"; // Import the tracked decorator
import I18n from "I18n";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class YourControllerName extends Controller {
  @service dialog;

  @tracked addresses = []; // Mark addresses as tracked

  @action
  resetPassword(address) {
    address.resetPassword();
  }

  @action
  async destroy(address) {
    const confirmed = await this.dialog.confirm({
      title: I18n.t("discourse-virtmail.addresses.delete_confirm"),
      body: I18n.t("discourse-virtmail.addresses.delete_confirm_body"),
      confirmButtonLabel: I18n.t("discourse-virtmail.addresses.delete_confirm_button"),
      cancelButtonLabel: I18n.t("cancel"),
    });

    if (confirmed) {
      try {
        await address.destroyRecord();
        this.model.removeObject(address);
      } catch (error) {
        popupAjaxError(error);
      }
    }
  }
}
