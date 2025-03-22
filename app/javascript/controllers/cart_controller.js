import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  async add(event) {
    event.preventDefault();
    const response = await post(event.target.action, { body: new FormData(event.target) });
    if (response.ok) {
      alert("Added to cart!");
    }
  }
}
