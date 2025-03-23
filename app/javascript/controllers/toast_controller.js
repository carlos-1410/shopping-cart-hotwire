import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    setTimeout(() => this.hide(), 3000);
  }

  hide() {
    this.element.classList.remove('show');
    setTimeout(() => this.element.remove(), 500);
  }
}
