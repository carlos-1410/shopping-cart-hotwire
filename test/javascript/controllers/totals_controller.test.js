import { Application } from '@hotwired/stimulus';
import TotalsController from '../../../app/javascript/controllers/totals_controller';

jest.mock("../../../app/javascript/services/ultils", () => ({
  formatCurrency: (num) => `$${(num / 100).toFixed(2)}`
}));

describe('TotalsController', () => {
  let application;

  beforeEach(() => {
    localStorage.setItem("cart-discount", "2000");

    document.body.innerHTML = `
      <div data-controller="totals"
           data-totals-total-value="10000">
        <span data-totals-target="price"></span>
        <span data-totals-target="discount"></span>
        <h3 data-totals-target="final"></h3>
        <input type="range" class="form-range" data-action="input->totals#update" value="2000">
      </div>
    `;

    application = Application.start();
    application.register('totals', TotalsController);
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = '';
    localStorage.clear();
  });

  test('updates discount, final total, and slider value', async () => {
    const element = document.querySelector('[data-controller="totals"]'),
      input = element.querySelector('input'),
      final = element.querySelector('[data-totals-target="final"]'),
      discount = element.querySelector('[data-totals-target="discount"]'),
      controller = application.getControllerForElementAndIdentifier(element, 'totals');

    await Promise.resolve();

    input.value = "100";
    controller.update({ target: input });

    expect(discount.innerHTML).toBe('$1.00');
    expect(final.innerHTML).toBe('$99.00');
    expect(input.value).toBe("100");
  });
});
