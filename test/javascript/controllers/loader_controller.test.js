import { Application } from "@hotwired/stimulus"
import LoaderController from "../../../app/javascript/controllers/loader_controller"

describe("LoaderController", () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="loader" class="loader-overlay d-none">
        <img loading="lazy" src="example.jpg" />
      </div>
    `;
    application = Application.start();
    application.register("loader", LoaderController);
  });

  afterEach(() => {
    application.stop();
    document.body.innerHTML = "";
  });

  test("removes the loader once image is loaded", () => {
    const overlay = document.querySelector(".loader-overlay"),
      img = overlay.querySelector("img");

    expect(overlay.classList.contains("d-none")).toBe(false);

    img.dispatchEvent(new Event("load"));

    expect(overlay.classList.contains("d-none")).toBe(true);
  });
});
