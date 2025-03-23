import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'error'];

  connect() {
    if (this.hasInputTarget && this.hasErrorTarget) {
      this.inputTarget.addEventListener('input', () => {
        this.errorTarget.classList.add('d-none');
      });
    }
  }
};
