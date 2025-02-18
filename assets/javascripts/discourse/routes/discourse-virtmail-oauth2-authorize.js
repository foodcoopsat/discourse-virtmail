import { action } from "@ember/object";
import DiscourseRoute from 'discourse/routes/discourse'

export default class Oauth2Authorize extends DiscourseRoute{
  controllerName= "oauth2-authorize";
}
