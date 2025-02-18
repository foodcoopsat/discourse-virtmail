import DiscourseRoute from 'discourse/routes/discourse'

export default class AddressesShow extends DiscourseRoute{
  controllerName = "addresses-show";

  model(params) {
    if (params.id === "new") {
      return this.store.createRecord("address");
    }
    return this.store.find("address", params.id);
  }

}
