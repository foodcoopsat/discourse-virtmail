import Component from "@glimmer/component";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";
import VirtmailList from "../../components/virtmail-list";

export default class FieldContainer extends Component {
  @service currentUser;

  <template>
    {{#if this.currentUser.admin}}
      <div class="control-group">
        <label class="control-label">{{i18n
            "discourse-virtmail.addresses.virtmail_domains"
          }}</label>
        <VirtmailList @values={{@outletArgs.group.virtmail_domains}} />
      </div>
    {{/if}}
  </template>
}
