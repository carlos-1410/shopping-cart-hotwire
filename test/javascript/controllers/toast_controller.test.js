import { Application } from '@hotwired/stimulus'
import ToastController from '../../../app/javascript/controllers/toast_controller'

describe('ToastController', () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller='toast' class='toast show'>Hello!</div>
    `;

    jest.useFakeTimers();

    application = Application.start();
    application.register('toast', ToastController);
  });

  afterEach(() => {
    application.stop();
    jest.useRealTimers();
    document.body.innerHTML = '';
  });

  test('removes the popup after the timeout', async () => {
    const toast = document.querySelector('.toast');
    expect(toast).not.toBeNull();

    jest.advanceTimersByTime(4000);

    await Promise.resolve();

    expect(document.body.contains(toast)).toBe(false);
  });
});
