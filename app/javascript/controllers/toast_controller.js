import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("CONNECT")
    setTimeout(() => this.hide(), 3000);
  }

  hide() {
    console.log("HIDE!!!")
    this.element.classList.remove("show");
    setTimeout(() => this.element.remove(), 500);
  }
}
