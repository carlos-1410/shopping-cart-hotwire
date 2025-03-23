import { Application } from '@hotwired/stimulus';
import FieldErrorsController from '../../../app/javascript/controllers/field_errors_controller';

describe('FieldErrorsController', () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller='field-errors'>
        <input data-field-errors-target='input' />
        <span data-field-errors-target='error' class='error'>This is required</span>
      </div>
    `;
    application = Application.start();
    application.register('field-errors', FieldErrorsController);
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = '';
  });

  test('hides the error message on input', () => {
    const input = document.querySelector('input'),
      error = document.querySelector('.error');

    expect(error.classList.contains('d-none')).toBe(false);

    input.value = 'test';
    input.dispatchEvent(new Event('input'));

    expect(error.classList.contains('d-none')).toBe(true);
  })
});
