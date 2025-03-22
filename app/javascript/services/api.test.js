import Api from "../services/api";
import { toast } from "react-toastify";

jest.mock("react-toastify", () => ({
  toast: {
    success: jest.fn(),
    error: jest.fn(),
  },
}));

global.fetch = jest.fn();

describe("Api Service", () => {
  beforeAll(() => {
    document.head.innerHTML = `
      <meta name="csrf-token" content="test-csrf-token">
    `;
  });

  beforeEach(() => {
    fetch.mockClear();
    toast.success.mockClear();
    toast.error.mockClear();
  });

  it("fetches cart items successfully", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue([{ id: 1, name: "Item 1" }]),
    });

    const data = await Api.fetchCartItems();

    expect(fetch).toHaveBeenCalledWith("/api/v1/cart_items", expect.any(Object));
    expect(data).toEqual([{ id: 1, name: "Item 1" }]);
  });

  it("handles error when fetching cart items", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: jest.fn().mockResolvedValue({ errors: "Failed to fetch" }),
    });

    await Api.fetchCartItems();

    expect(toast.error).toHaveBeenCalledWith("Failed to fetch", expect.any(Object));
  });

  it("fetches a single cart item successfully", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue({ id: 1, name: "Item 1" }),
    });

    const data = await Api.fetchCartItem(1);

    expect(fetch).toHaveBeenCalledWith("/api/v1/cart_items/1", expect.any(Object));
    expect(data).toEqual({ id: 1, name: "Item 1" });
  });

  it("updates cart item and shows success toast", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue({ message: "Item updated" }),
    });

    await Api.updateCartItem({ productId: 1, quantity: 2 });

    expect(toast.success).toHaveBeenCalledWith("Item updated", expect.any(Object));
  });

  it("handles error when updating cart item", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: jest.fn().mockResolvedValue({ errors: "Update failed" }),
    });

    await Api.updateCartItem({ productId: 1, quantity: 2 });

    expect(toast.error).toHaveBeenCalledWith("Update failed", expect.any(Object));
  });

  it("removes a cart item and shows success toast", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue({ message: "Item removed" }),
    });

    await Api.removeCartItem(1);

    expect(toast.success).toHaveBeenCalledWith("Item removed", expect.any(Object));
  });

  it("handles error when removing a cart item", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: jest.fn().mockResolvedValue({ errors: "Remove failed" }),
    });

    await Api.removeCartItem(1);

    expect(toast.error).toHaveBeenCalledWith("Remove failed", expect.any(Object));
  });

  it("resets the cart and shows success toast", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue({ message: "Cart reset" }),
    });

    await Api.resetCart();

    expect(toast.success).toHaveBeenCalledWith("Cart reset", expect.any(Object));
  });

  it("handles error when resetting the cart", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: jest.fn().mockResolvedValue({ errors: "Reset failed" }),
    });

    await Api.resetCart();

    expect(toast.error).toHaveBeenCalledWith("Reset failed", expect.any(Object));
  });

  it("fetches products successfully", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue([{ id: 1, name: "Product 1" }]),
    });

    const data = await Api.fetchProducts();

    expect(fetch).toHaveBeenCalledWith("/api/v1/products", expect.any(Object));
    expect(data).toEqual([{ id: 1, name: "Product 1" }]);
  });

  it("removes a product and shows success toast", async () => {
    fetch.mockResolvedValueOnce({
      ok: true,
      json: jest.fn().mockResolvedValue({ message: "Product removed" }),
    });

    await Api.removeProduct(1);

    expect(toast.success).toHaveBeenCalledWith("Product removed", expect.any(Object));
  });

  it("handles error when removing a product", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: jest.fn().mockResolvedValue({ errors: "Remove failed" }),
    });

    await Api.removeProduct(1);

    expect(toast.error).toHaveBeenCalledWith("Remove failed", expect.any(Object));
  });
});
