import DiscourseRoute from 'discourse/routes/discourse'

export default DiscourseRoute.extend({
  controllerName: "addresses-show",

  model(params) {
    if (params.id === "new") {
      return this.store.createRecord("address");
    }
    return this.store.find("address", params.id);
  },

  renderTemplate() {
    this.render("addresses-show");
  }
});
