export default function () {
  this.route("discourse-virtmail", function () {
    this.route("index", { path: "/" });
    this.route("addresses", function () {
      this.route("show", { path: "/:id" });
      this.route("index", { path: "/" });
    });
    this.route("oauth2", function () {
      this.route("authorize");
      this.route("token");
    });
  });
};
