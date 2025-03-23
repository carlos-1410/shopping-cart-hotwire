/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ./images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('./images', true)
// const imagePath = (name) => images(name, true)
import Rails from '@rails/ujs';
Rails.start();

// stimulus and turbo stuff
import { Application } from '@hotwired/stimulus';
import '@hotwired/turbo-rails'

const application = Application.start();

import ImagePreviewController from '../controllers/image_preview_controller';
import ProductsController from '../controllers/products_controller';
import ToastController from '../controllers/toast_controller';
import FieldErrorsController from '../controllers/field_errors_controller';
import QuantityController from '../controllers/quantity_controller';
import TotalsController from '../controllers/totals_controller';
import LoaderController from '../controllers/loader_controller';

application.register('image-preview', ImagePreviewController);
application.register('product', ProductsController);
application.register('toast', ToastController);
application.register('field-errors', FieldErrorsController);
application.register('quantity', QuantityController);
application.register('totals', TotalsController);
application.register('loader', LoaderController);

export default application;
