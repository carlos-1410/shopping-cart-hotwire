import { Controller } from '@hotwired/stimulus';
import { formatCurrency } from '../services/ultils';

export default class extends Controller {
  static targets = ['discount', 'price', 'final'];
  static values = {
    total: Number
  };

  // I didn't want the discount to reset after each, so I store it in localStorage
  connect() {
    this.discountValue = Number(localStorage.getItem('cart-discount') || 2500);
    this.render();
  }

  update(event) {
    this.discountValue = Number(event.target.value);
    localStorage.setItem('cart-discount', this.discountValue);
    this.render();
  }

  render() {
    this.discountTarget.innerText = formatCurrency(this.discountValue);

    const final = Math.max(this.totalValue - this.discountValue, 0);
    this.finalTarget.innerText = formatCurrency(final);

    const slider = this.element.querySelector('input[type="range"]');
    if (slider) slider.value = this.discountValue;
  }
}