import { ajax } from "discourse/lib/ajax";

import RestModel from "discourse/models/rest";

export default class VirtmailAdressesModel extends RestModel {
  createProperties() {
    return this.getProperties("domain", "localpart", "comment", "destinations", "forward_only", "quota_bytes", "allowed_users");
  }

  updateProperties() {
    return this.createProperties();
  }

  resetPassword() {
    const path = this.store
      .adapterFor("address")
      .pathFor(this.store, "address", this.id);

    return ajax(`${path}/reset_password`, {
      type: "POST",
    }).then((result) => this.set("password", result.password));
  }
}
