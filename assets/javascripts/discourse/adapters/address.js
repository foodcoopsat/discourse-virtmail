import RestAdapter from "discourse/adapters/rest";

export default class VirtmailAdressesAdapter extends RestAdapter {
  jsonMode = true;

  basePath() {
    return "/discourse-virtmail/";
  }
}
