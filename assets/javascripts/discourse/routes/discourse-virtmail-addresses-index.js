import DiscourseRoute from 'discourse/routes/discourse'

export default DiscourseRoute.extend({
  controllerName: "addresses-index",

  model(params) {
    return this.store.findAll("address");
  },

  renderTemplate() {
    this.render("addresses-index");
  }
});
