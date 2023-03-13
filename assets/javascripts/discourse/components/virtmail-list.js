import Component from "@ember/component";
import { action, computed } from "@ember/object";

export default class VirtmailList extends Component {
  inputDelimiter = null;
  newValue = "";
  collection = null;
  values = null;

  didReceiveAttrs() {
    this._super(...arguments);

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
}
