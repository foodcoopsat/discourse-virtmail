import Component from "@glimmer/component";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";

export default class VirtmailPassword extends Component {
  @action
  resetVirtmailPassword(model) {
    ajax(`/discourse-virtmail/u/${model.username_lower}/reset_password`, {
      type: "POST",
    })
      .then((json) => {
        model.set("virtmail_password", json.password);
      })
      .catch(popupAjaxError);
  }

  <template>
    <div class="control-group pref-title">
      <label class="control-label">{{i18n
          "discourse-virtmail.user_preferences_security.title"
        }}</label>
      <div class="controls">
        {{#if @outletArgs.model.virtmail_password}}
          <code>{{@outletArgs.model.virtmail_password}}</code>
        {{/if}}
        <DButton
          @action={{this.resetVirtmailPassword}}
          @actionParam={{@outletArgs.model}}
          @icon="sync"
          @label="discourse-virtmail.user_preferences_security.reset_password"
        />
      </div>
    </div>
  </template>
}
