import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { i18n } from "discourse-i18n";

export default <template>
  <h1>{{i18n "discourse-virtmail.oauth2.authorize.title"}}</h1>

  {{#if @controller.hasAddresses}}
    Bitte wähle eine E-Mail-Adresse:
    <ul>
      {{#each @controller.addresses as |addr|}}
        <li><a
            role="button"
            {{on "click" (fn @controller.authorize addr.address)}}
          >{{addr.address}}</a>{{#if addr.comment}}
            ({{addr.comment}}){{/if}}</li>
      {{/each}}
    </ul>
  {{else}}
    Für dich sind keine E-Mail-Adressen konfiguriert.
  {{/if}}
</template>;
