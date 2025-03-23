import { Controller } from '@hotwired/stimulus';
import { Turbo } from '@hotwired/turbo-rails';

export default class extends Controller {
  static values = {
    quantity: Number,
    cartItemId: Number,
    productId: Number
  };

  connect() {
    this.render();
  }

  increase() {
    this.quantityValue++;
    this.updateQuantity();
  }

  decrease() {
    if (this.quantityValue <= 1) {
      const confirmDelete = confirm("Are you sure you want to remove this item from your cart?");
      if (!confirmDelete) return;

      this.removeItem();
      return;
    }

    this.quantityValue--;
    this.updateQuantity();
  }

  updateQuantity() {
    this.render();

    fetch('/cart_items/upsert', {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        product_id: this.productIdValue,
        quantity: this.quantityValue
      })
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html));
  }

  removeItem() {
    fetch(`/cart_items/${this.cartItemIdValue}`, {
      method: "DELETE",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html));
  }

  render() {
    this.element.querySelector('[data-quantity-target="display"]').innerText = this.quantityValue;
  }
}
