import { Input, Textarea } from "@ember/component";
import { LinkTo } from "@ember/routing";
import DButton from "discourse/components/d-button";
import TextField from "discourse/components/text-field";
import icon from "discourse/helpers/d-icon";
import UserChooser from "discourse/select-kit/components/user-chooser";
import { i18n } from "discourse-i18n";
import VirtmailList from "../components/virtmail-list";

export default <template>
  <LinkTo @route="discourse-virtmail.addresses" class="go-back">
    {{icon "arrow-left"}}
    {{i18n "discourse-virtmail.addresses.go_back"}}
  </LinkTo>

  <div class="web-hook-container">
    <div>Address:
      <TextField @value={{@model.localpart}} />
      @
      <TextField @value={{@model.domain}} /></div>
    <div>Comment:<br /><Textarea @value={{@model.comment}} /></div>
    <div><b>Destinations:</b><br />
      <Input @type="checkbox" @checked={{@model.forward_only}} />
      {{i18n "discourse-virtmail.addresses.forward_only"}}<br />
      <VirtmailList @values={{@model.destinations}} /></div>
    <div><b>Allowed Users:</b><br />
      <UserChooser @value={{@model.allowed_users}} /></div>

    <div class="controls">
      <DButton
        @action={{@controller.save}}
        @disabled={{@controller.saveDisabled}}
        @translatedLabel={{@controller.saveButtonText}}
        class="btn-default"
      />
      <span class="saving">{{@controller.savingStatus}}</span>
    </div>
  </div>
</template>;
