import { action, computed } from "@ember/object";
import Controller from "@ember/controller";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Controller.extend({
  addresses: [],

  init() {
    this._super(arguments);

    ajax(`/discourse-virtmail/oauth2/authorize`, {
      type: "GET"
    }).then((result) => {
      this.set("addresses", result.addresses);
    })
      .catch(popupAjaxError);
  },

  @computed("addresses")
  get hasAddresses() {
  // console.log("hasAddresses")
  return true;
  return !!this.addresses.length;
},

@action
authorize(email) {
  return ajax(`/discourse-virtmail/oauth2/authorize`, {
    type: "POST",
    data: {
      email: email,
      search: location.search.substr(1)
    }
  }).then((result) => {
    location.href = result.location;
  })
    .catch(popupAjaxError);
},

});
