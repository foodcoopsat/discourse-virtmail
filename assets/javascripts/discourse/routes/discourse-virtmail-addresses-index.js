import DiscourseRoute from 'discourse/routes/discourse'

export default class AddressIndex extends DiscourseRoute{
  controllerName = "addresses-index";

  async model(params) {
    const addr = await this.store.findAll("address");
    return addr;
  }

}
