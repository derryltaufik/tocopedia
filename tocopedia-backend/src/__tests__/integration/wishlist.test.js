require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createCategory, createProduct } = require("../helpers");

describe("Wishlist Endpoints", () => {
  let user, token, product;

  beforeEach(async () => {
    const result = await createTestUser({ email: "user@test.com" });
    user = result.user;
    token = result.token;

    const { user: seller } = await createTestUser({ email: "seller@test.com" });
    const category = await createCategory();
    product = await createProduct(seller, category);
  });

  describe("GET /wishlist", () => {
    it("should return user wishlist", async () => {
      const res = await request(app)
        .get("/wishlist")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.wishlist.owner._id).toBe(user._id.toString());
    });
  });

  describe("POST /wishlist/:product_id", () => {
    it("should add product to wishlist", async () => {
      const res = await request(app)
        .post(`/wishlist/${product._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(201);
      expect(res.body.data.wishlist.wishlist_products).toHaveLength(1);
    });

    it("should not duplicate product in wishlist", async () => {
      await request(app)
        .post(`/wishlist/${product._id}`)
        .set("Authorization", `Bearer ${token}`);

      await request(app)
        .post(`/wishlist/${product._id}`)
        .set("Authorization", `Bearer ${token}`);

      const res = await request(app)
        .get("/wishlist")
        .set("Authorization", `Bearer ${token}`);

      expect(res.body.data.wishlist.wishlist_products).toHaveLength(1);
    });
  });

  describe("DELETE /wishlist/:product_id", () => {
    it("should remove product from wishlist", async () => {
      await request(app)
        .post(`/wishlist/${product._id}`)
        .set("Authorization", `Bearer ${token}`);

      const res = await request(app)
        .delete(`/wishlist/${product._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(201);
      expect(res.body.data.wishlist.wishlist_products).toHaveLength(0);
    });
  });
});
