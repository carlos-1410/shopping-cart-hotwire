import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.show();

    const images = document.querySelectorAll('img[loading="lazy"]');

    if (images.length === 0) {
      this.hide();
      return;
    }

    let loaded = 0;
    const total = images.length;

    const onImageLoad = () => {
      loaded++;
      if (loaded >= total) this.hide();
    }

    images.forEach(img => {
      if (img.complete) {
        onImageLoad();
      } else {
        img.addEventListener('load', onImageLoad);
        img.addEventListener('error', onImageLoad);
      }
    })
  }

  show() {
    this.element.classList.remove('d-none');
  }

  hide() {
    this.element.classList.add('d-none');
  }
}
