import Component, { Input } from "@ember/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action, computed } from "@ember/object";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";

export default class VirtmailList extends Component {
  inputDelimiter = null;
  newValue = "";
  collection = null;
  values = null;

  didReceiveAttrs() {
    super.didReceiveAttrs(...arguments);

    this.set("collection", this.values || []);
  }

  keyDown(event) {
    if (event.which === 13) {
      this.addValue(this.newValue);
      return;
    }
  }

  @action
  changeValue(index, event) {
    this.collection.replace(index, 1, [event.target.value]);
    this.collection.arrayContentDidChange(index);
    this._saveValues();
  }

  @action
  addValue(newValue) {
    if (this.inputEmpty) {
      return;
    }

    this.set("newValue", null);
    this.collection.addObject(newValue);
    this._saveValues();
  }

  @action
  removeValue(value) {
    this.collection.removeObject(value);
    this._saveValues();
  }

  @computed("newValue")
  get inputEmpty() {
    return !this.newValue;
  }

  _saveValues() {
    this.set("values", this.collection);
  }

  <template>
    {{#if this.collection}}
      <div class="values">
        {{#each this.collection as |value index|}}
          <div data-index={{index}} class="value">
            <DButton
              @action={{this.removeValue}}
              @actionParam={{value}}
              @icon="times"
              class="remove-value-btn btn-small"
            />

            <Input
              title={{value}}
              @value={{value}}
              class="value-input"
              {{on "focusout" (fn this.changeValue index)}}
            />
          </div>
        {{/each}}
      </div>
    {{/if}}

    <div class="simple-list-input">
      <Input
        @type="text"
        @value={{this.newValue}}
        placeholder={{i18n "admin.site_settings.simple_list.add_item"}}
        class="add-value-input"
        autocomplete="off"
        autocorrect="off"
        autocapitalize="off"
      />

      <DButton
        @action={{this.addValue}}
        @actionParam={{this.newValue}}
        @disabled={{this.inputEmpty}}
        @icon="plus"
        class="add-value-btn btn-small"
      />
    </div>
  </template>
}
