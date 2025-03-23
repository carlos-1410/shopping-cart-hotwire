import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  imageLoaded(event) {
    event.target.classList.add('loaded');
  }

  remove(event) {
    if (!confirm('Are you sure you want to remove this product?')) {
      event.preventDefault();
    }
  }
}