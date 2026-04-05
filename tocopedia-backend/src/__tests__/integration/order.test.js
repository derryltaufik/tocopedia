require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createCategory, createProduct, createAddress } = require("../helpers");

describe("Order Endpoints", () => {
  let buyer, buyerToken, seller, category, product, address;

  beforeEach(async () => {
    const buyerResult = await createTestUser({ name: "Buyer", email: "buyer@test.com" });
    buyer = buyerResult.user;
    buyerToken = buyerResult.token;

    const sellerResult = await createTestUser({ name: "Seller", email: "seller@test.com" });
    seller = sellerResult.user;

    category = await createCategory();
    product = await createProduct(seller, category, { stock: 10, price: 5000 });
    address = await createAddress(buyer);

    // Add product to cart
    await request(app)
      .patch(`/cart/add/${product._id}`)
      .set("Authorization", `Bearer ${buyerToken}`);
  });

  describe("POST /orders/checkout", () => {
    it("should create order from cart", async () => {
      const res = await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({ address: address._id });

      expect(res.status).toBe(201);
      expect(res.body.data.order.status).toBe("unpaid");
      expect(res.body.data.order.order_items).toHaveLength(1);
    });

    it("should reject checkout without address", async () => {
      const res = await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({});

      expect(res.status).toBe(404);
    });
  });

  describe("GET /orders", () => {
    it("should return user orders", async () => {
      await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({ address: address._id });

      const res = await request(app)
        .get("/orders")
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.results).toHaveLength(1);
    });
  });

  describe("PATCH /orders/:order_id/pay", () => {
    it("should pay an unpaid order", async () => {
      const checkout = await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({ address: address._id });

      const orderId = checkout.body.data.order._id;

      const res = await request(app)
        .patch(`/orders/${orderId}/pay`)
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.order.status).toBe("paid");
    });

    it("should reject pay by non-buyer", async () => {
      const checkout = await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({ address: address._id });

      const orderId = checkout.body.data.order._id;
      const { token: otherToken } = await createTestUser({ email: "other@test.com" });

      const res = await request(app)
        .patch(`/orders/${orderId}/pay`)
        .set("Authorization", `Bearer ${otherToken}`);

      expect(res.status).toBe(403);
    });
  });

  describe("PATCH /orders/:order_id/cancel", () => {
    it("should cancel an unpaid order", async () => {
      const checkout = await request(app)
        .post("/orders/checkout")
        .set("Authorization", `Bearer ${buyerToken}`)
        .send({ address: address._id });

      const orderId = checkout.body.data.order._id;

      const res = await request(app)
        .patch(`/orders/${orderId}/cancel`)
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.order.status).toBe("cancelled");
    });
  });
});
