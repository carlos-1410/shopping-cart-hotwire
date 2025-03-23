import { Application } from '@hotwired/stimulus';
import ImagePreviewController from '../../../app/javascript/controllers/image_preview_controller';

describe('ImagePreviewController', () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller='image-preview'>
        <input type='file' data-image-preview-target='input'>
        <img data-image-preview-target='preview' style='display: none;' />
      </div>
    `;
    application = Application.start();
    application.register('image-preview', ImagePreviewController);
  })

  afterEach(() => {
    application.stop();
    document.body.innerHTML = '';
  });

  test('previews the image on file select', () => {
    const input = document.querySelector('input'),
      preview = document.querySelector('img'),
      file = new Blob(['file content'], { type: 'image/png' }),
      fileList = {
        0: file,
        length: 1,
        item: (_) => file,
      };

    jest.spyOn(FileReader.prototype, 'readAsDataURL').mockImplementation(function () {
      this.onload({ target: { result: 'data:image/png;base64,testdata' } });
    });

    Object.defineProperty(input, 'files', {
      value: fileList
    });

    input.dispatchEvent(new Event('change'));

    expect(preview.src).toContain('data:image/png;base64,testdata');
    expect(preview.style.display).toBe('block');
  });
});
