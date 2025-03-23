import { Application } from '@hotwired/stimulus';
import ProductsController from '../../../app/javascript/controllers/products_controller';

describe('ProductsController', () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="products">
        <img class="product-image" data-action="load->products#imageLoaded" />
        <a href="#" data-action="products#remove">Delete</a>
      </div>
    `;
    application = Application.start();
    application.register('products', ProductsController);
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = '';
  });

  test("adds 'loaded' class on image load", () => {
    const img = document.querySelector('.product-image'),
        event = new Event('load');
    img.dispatchEvent(event);
    expect(img.classList.contains('loaded')).toBe(true);
  });

  test('prevents delete if user cancels', () => {
    const link = document.querySelector('a'),
        event = new Event('click');
    jest.spyOn(window, 'confirm').mockReturnValue(false);
    jest.spyOn(event, 'preventDefault');

    link.dispatchEvent(event);

    expect(event.preventDefault).toHaveBeenCalled();
  });
});
