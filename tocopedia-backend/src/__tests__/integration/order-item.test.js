require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createCategory, createProduct, createAddress } = require("../helpers");
const { Product } = require("../../models/product");

describe("OrderItem Endpoints", () => {
  let buyer, buyerToken, seller, sellerToken, category, product, address, orderId;

  beforeEach(async () => {
    const buyerResult = await createTestUser({ name: "Buyer", email: "buyer@test.com" });
    buyer = buyerResult.user;
    buyerToken = buyerResult.token;

    const sellerResult = await createTestUser({ name: "Seller", email: "seller@test.com" });
    seller = sellerResult.user;
    sellerToken = sellerResult.token;

    category = await createCategory();
    product = await createProduct(seller, category, { stock: 10, price: 5000 });
    address = await createAddress(buyer);

    // Add to cart and checkout
    await request(app)
      .patch(`/cart/add/${product._id}`)
      .set("Authorization", `Bearer ${buyerToken}`);

    const checkout = await request(app)
      .post("/orders/checkout")
      .set("Authorization", `Bearer ${buyerToken}`)
      .send({ address: address._id });

    orderId = checkout.body.data.order._id;

    // Pay the order
    await request(app)
      .patch(`/orders/${orderId}/pay`)
      .set("Authorization", `Bearer ${buyerToken}`);
  });

  describe("GET /order-items/seller", () => {
    it("should return seller order items", async () => {
      const res = await request(app)
        .get("/order-items/seller")
        .set("Authorization", `Bearer ${sellerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.results.length).toBeGreaterThanOrEqual(1);
    });
  });

  describe("GET /order-items/buyer", () => {
    it("should return buyer order items", async () => {
      const res = await request(app)
        .get("/order-items/buyer")
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.results.length).toBeGreaterThanOrEqual(1);
    });
  });

  describe("Order lifecycle: process → send → complete", () => {
    it("should complete the full order lifecycle", async () => {
      // Get the order item ID
      const sellerItems = await request(app)
        .get("/order-items/seller")
        .set("Authorization", `Bearer ${sellerToken}`);

      const orderItemId = sellerItems.body.data.results[0]._id;

      // Seller processes
      const processRes = await request(app)
        .patch(`/order-items/${orderItemId}/process`)
        .set("Authorization", `Bearer ${sellerToken}`);
      expect(processRes.status).toBe(200);
      expect(processRes.body.data.order_item.status).toBe("processing");

      // Seller sends with airwaybill
      const sendRes = await request(app)
        .patch(`/order-items/${orderItemId}/send`)
        .set("Authorization", `Bearer ${sellerToken}`)
        .send({ airwaybill: "JNE123456" });
      expect(sendRes.status).toBe(200);
      expect(sendRes.body.data.order_item.status).toBe("sent");

      // Buyer completes
      const completeRes = await request(app)
        .patch(`/order-items/${orderItemId}/complete`)
        .set("Authorization", `Bearer ${buyerToken}`);
      expect(completeRes.status).toBe(200);
      expect(completeRes.body.data.order_item.status).toBe("completed");

      // Verify stock was decremented
      const updatedProduct = await Product.findById(product._id);
      expect(updatedProduct.stock).toBe(9);
    });
  });
});
