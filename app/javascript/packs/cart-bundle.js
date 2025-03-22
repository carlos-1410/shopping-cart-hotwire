import ReactOnRails from 'react-on-rails';

import FlashAlerts from '../bundles/Cart/components/FlashAlerts';
import Cart from '../bundles/Cart/components/Cart';
import CartItem from '../bundles/Cart/components/CartItem';
import Product from '../bundles/Products/components/Product';
import ProductList from '../bundles/Products/components/ProductList';
import Quantity from '../bundles/Cart/components/Quantity';
import Totals from '../bundles/Cart/components/Totals';

// This is how react_on_rails can see the Products in the browser.
ReactOnRails.register({
  Cart,
  CartItem,
  FlashAlerts,
  Product,
  ProductList,
  Totals,
  Quantity
});
