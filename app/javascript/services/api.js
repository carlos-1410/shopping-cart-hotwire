import { toast } from "react-toastify";
const API_BASE_URL = "/api/v1";

const request = async (url, method = "GET", body = null) => {
  const options = {
    method,
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
    },
    body: body ? JSON.stringify(body) : null,
  };

  const response = await fetch(`${API_BASE_URL}${url}`, options);
  const data = await response.json();

  if (!response.ok) {
    notifyError(data.errors || "Something went wrong!");
  } else {
    if (method !== "GET") notifySuccess(data.message || "Operation successful!");
  }
  return data;
};

const notifySuccess = (message) => {
  toast.success(message, {
    position: "top-right",
    autoClose: 3000,
  });
};

const notifyError = (message) => {
  toast.error(message, {
    position: "top-right",
    autoClose: 3000,
  });
};

// API Methods
const Api = {
  // cart methods
  fetchCartItems: () => request("/cart_items"),
  fetchCartItem: (productId) => request(`/cart_items/${productId}`),
  updateCartItem: (data) => request(`/cart_items/upsert`, "POST", data),
  removeCartItem: (id) => request(`/cart_items/${id}`, "DELETE"),
  resetCart: () => request("/cart_items/reset", "DELETE", {}),
  // products
  fetchProducts: () => request("/products"),
  removeProduct: (id) => request(`/products/${id}`, "DELETE"),
};

export default Api;