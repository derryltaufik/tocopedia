require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createCategory, createProduct } = require("../helpers");

describe("Cart Endpoints", () => {
  let buyer, buyerToken, seller, category, product;

  beforeEach(async () => {
    const buyerResult = await createTestUser({ name: "Buyer", email: "buyer@test.com" });
    buyer = buyerResult.user;
    buyerToken = buyerResult.token;

    const sellerResult = await createTestUser({ name: "Seller", email: "seller@test.com" });
    seller = sellerResult.user;

    category = await createCategory();
    product = await createProduct(seller, category);
  });

  describe("GET /cart", () => {
    it("should return user cart", async () => {
      const res = await request(app)
        .get("/cart")
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.cart.owner._id).toBe(buyer._id.toString());
    });
  });

  describe("PATCH /cart/add/:product_id", () => {
    it("should add product to cart", async () => {
      const res = await request(app)
        .patch(`/cart/add/${product._id}`)
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.cart.cart_items).toHaveLength(1);
    });

    it("should not allow adding own product", async () => {
      const { user: seller2, token: seller2Token } = await createTestUser({
        name: "Seller2",
        email: "seller2@test.com",
      });
      const ownProduct = await createProduct(seller2, category);

      const res = await request(app)
        .patch(`/cart/add/${ownProduct._id}`)
        .set("Authorization", `Bearer ${seller2Token}`);

      expect(res.status).toBe(403);
    });
  });

  describe("PATCH /cart/clear", () => {
    it("should clear the cart", async () => {
      await request(app)
        .patch(`/cart/add/${product._id}`)
        .set("Authorization", `Bearer ${buyerToken}`);

      const res = await request(app)
        .patch("/cart/clear")
        .set("Authorization", `Bearer ${buyerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.cart.cart_items).toHaveLength(0);
    });
  });
});
