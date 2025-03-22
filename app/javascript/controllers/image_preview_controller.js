import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview"];

  connect() {
    this.inputTarget.addEventListener("change", (event) => this.previewImage(event));
  }

  previewImage(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result;
        this.previewTarget.style.display = "block";
      };
      reader.readAsDataURL(file);
    }
  }
}
