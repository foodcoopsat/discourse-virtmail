import { action } from "@ember/object";
import Controller, { inject as controller } from "@ember/controller";
import EmberObject from "@ember/object";
import I18n from "I18n";
import { alias } from "@ember/object/computed";
import bootbox from "bootbox";
import discourseComputed from "discourse-common/utils/decorators";
import { extractDomainFromUrl } from "discourse/lib/utilities";
import { isAbsoluteURL } from "discourse-common/lib/get-url";
import { empty } from "@ember/object/computed";

import { isEmpty } from "@ember/utils";
import { popupAjaxError } from "discourse/lib/ajax-error";


// import Controller from "@ember/controller";
export default Controller.extend({
  // addresses: controller(),

  addresses: {
  },

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
          this.transitionToRoute("discourse-virtmail.addresses.show", model.get("id"));
        }
      })
      .catch(popupAjaxError);
  },
});
