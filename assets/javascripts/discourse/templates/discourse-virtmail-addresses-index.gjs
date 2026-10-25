import { LinkTo } from "@ember/routing";
import DButton from "discourse/components/d-button";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default <template>
  <div class="virtmal-addresses-listing">
    <div class="new-virtmal-address">
      <LinkTo
        @route="discourse-virtmail.addresses.show"
        @model="new"
        class="btn btn-default"
      >
        {{icon "plus"}}
        {{i18n "discourse-virtmail.addresses.new"}}
      </LinkTo>
    </div>
    <table class="table" style="width: 100%;">
      <thead>
        <tr>
          <th style="width: 25%;">{{i18n
              "discourse-virtmail.addresses.address"
            }}</th>
          <th>{{i18n "discourse-virtmail.addresses.comment"}}</th>
          <th style="width: 20em;">{{i18n
              "discourse-virtmail.addresses.password"
            }}</th>
          <th style="width: 5em;">&nbsp;</th>
        </tr>
      </thead>
      <tbody>
        {{#each @model as |addr|}}
          <tr style="height: 3em;">
            <td>{{addr.address}}</td>
            <td>{{addr.comment}}</td>
            <td>
              {{#if addr.password}}
                <code>{{addr.password}}</code>
              {{else}}
                <DButton
                  @action={{@controller.resetPassword}}
                  @actionParam={{addr}}
                  @icon="sync"
                  @label="discourse-virtmail.addresses.reset_password"
                />
              {{/if}}
            </td>
            <td class="key-controls">
              <LinkTo
                @route="discourse-virtmail.addresses.show"
                @model={{addr}}
                class="btn btn-default no-text"
              >
                {{icon "far-edit"}}
              </LinkTo>
              <DButton
                class="destroy btn-danger"
                @action={{@controller.destroy}}
                @actionParam={{addr}}
                @icon="times"
                @title="delete"
              />
            </td>
          </tr>
        {{/each}}
      </tbody>
    </table>
  </div>
</template>;
