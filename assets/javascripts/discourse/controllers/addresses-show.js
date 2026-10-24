import Controller from "@ember/controller";
import { action } from "@ember/object";
import { service } from "@ember/service";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Controller.extend({
  router: service(),

  @discourseComputed("model.isSaving", "saved", "saveButtonDisabled")
  savingStatus(isSaving, saved, saveButtonDisabled) {
    if (isSaving) {
      return I18n.t("saving");
    } else if (!saveButtonDisabled && saved) {
      return I18n.t("saved");
    }
    // Use side effect of validation to clear saved text
    this.set("saved", false);
    return "";
  },

  @discourseComputed("model.isNew")
  saveButtonText(isNew) {
    return isNew
      ? I18n.t("admin.web_hooks.create")
      : I18n.t("admin.web_hooks.save");
  },

  @action
  save() {
    this.set("saved", false);
    const model = this.model;
    const isNew = model.get("isNew");

    return model
      .save()
      .then(() => {
        this.set("saved", true);

        if (isNew) {
          this.router.transitionTo("discourse-virtmail.addresses.show", model.get("id"));
        }
      })
      .catch(popupAjaxError);
  },
});
