require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createCategory, createProduct } = require("../helpers");
const mongoose = require("mongoose");

describe("Product Endpoints", () => {
  let seller, sellerToken, category;

  beforeEach(async () => {
    const result = await createTestUser({ name: "Seller", email: "seller@test.com" });
    seller = result.user;
    sellerToken = result.token;
    category = await createCategory();
  });

  describe("POST /products", () => {
    it("should create a product", async () => {
      const res = await request(app)
        .post("/products")
        .set("Authorization", `Bearer ${sellerToken}`)
        .send({
          name: "New Product",
          images: ["https://example.com/img.png"],
          price: 15000,
          stock: 10,
          description: "A great product",
          category: category._id,
        });

      expect(res.status).toBe(201);
      expect(res.body.data.product.name).toBe("New Product");
      expect(res.body.data.product.owner._id).toBe(seller._id.toString());
    });

    it("should reject without auth", async () => {
      const res = await request(app)
        .post("/products")
        .send({ name: "Product", images: ["img.png"], price: 1000, description: "desc", category: category._id });

      expect(res.status).toBe(401);
    });
  });

  describe("GET /products/:id", () => {
    it("should return a product", async () => {
      const product = await createProduct(seller, category);
      const res = await request(app).get(`/products/${product._id}`);

      expect(res.status).toBe(200);
      expect(res.body.data.product.name).toBe(product.name);
    });

    it("should return 404 for non-existent product", async () => {
      const fakeId = new mongoose.Types.ObjectId();
      const res = await request(app).get(`/products/${fakeId}`);
      expect(res.status).toBe(404);
    });
  });

  describe("GET /products/search", () => {
    it("should search products by query", async () => {
      await createProduct(seller, category, { name: "Blue Shirt" });
      await createProduct(seller, category, { name: "Red Pants" });

      const res = await request(app).get("/products/search?q=shirt");
      expect(res.status).toBe(200);
      expect(res.body.data.results).toHaveLength(1);
      expect(res.body.data.results[0].name).toBe("Blue Shirt");
    });
  });

  describe("PATCH /products/:id", () => {
    it("should update own product", async () => {
      const product = await createProduct(seller, category);

      const res = await request(app)
        .patch(`/products/${product._id}`)
        .set("Authorization", `Bearer ${sellerToken}`)
        .send({ name: "Updated Name" });

      expect(res.status).toBe(200);
      expect(res.body.data.product.name).toBe("Updated Name");
    });

    it("should reject update by non-owner", async () => {
      const product = await createProduct(seller, category);
      const { token: otherToken } = await createTestUser({ email: "other@test.com" });

      const res = await request(app)
        .patch(`/products/${product._id}`)
        .set("Authorization", `Bearer ${otherToken}`)
        .send({ name: "Hacked" });

      expect(res.status).toBe(403);
    });

    it("should reject invalid update fields", async () => {
      const product = await createProduct(seller, category);

      const res = await request(app)
        .patch(`/products/${product._id}`)
        .set("Authorization", `Bearer ${sellerToken}`)
        .send({ owner: "someone_else" });

      expect(res.status).toBe(400);
    });
  });

  describe("DELETE /products/:id", () => {
    it("should delete own product", async () => {
      const product = await createProduct(seller, category);

      const res = await request(app)
        .delete(`/products/${product._id}`)
        .set("Authorization", `Bearer ${sellerToken}`);

      expect(res.status).toBe(200);
    });

    it("should reject delete by non-owner", async () => {
      const product = await createProduct(seller, category);
      const { token: otherToken } = await createTestUser({ email: "other2@test.com" });

      const res = await request(app)
        .delete(`/products/${product._id}`)
        .set("Authorization", `Bearer ${otherToken}`);

      expect(res.status).toBe(404);
    });
  });
});
