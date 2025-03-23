import { Application } from '@hotwired/stimulus';
import QuantityController from '../../../app/javascript/controllers/quantity_controller';

describe('QuantityController', () => {
  let application;

  jest.mock('@hotwired/turbo-rails', () => ({
    Turbo: {
      renderStreamMessage: jest.fn()
    }
  }));

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="quantity"
           data-quantity-product-id-value="1"
           data-quantity-cart-item-id-value="10"
           data-quantity-quantity-value="2">
        <span data-quantity-target="display">2</span>
      </div>
    `;
    application = Application.start();
    application.register('quantity', QuantityController);
    global.fetch = jest.fn(() => Promise.resolve({ text: () => Promise.resolve('<turbo-stream>') }));
  })

  afterEach(() => {
    application.stop();
    document.body.innerHTML = '';
    jest.resetAllMocks();
  });

  test('increments the quantity and updates the display', () => {
    const controller = document.querySelector("[data-controller='quantity']");
    const button = document.createElement('button');
    button.setAttribute('data-action', 'quantity#increase');
    controller.appendChild(button);

    button.click();

    const display = controller.querySelector("[data-quantity-target='display']");
    expect(display.innerText).toBe(2);
  });
});
