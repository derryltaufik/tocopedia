require("../setup");
const request = require("supertest");
const app = require("../../app");
const { Category } = require("../../models/category");
const mongoose = require("mongoose");

describe("Category Endpoints", () => {
  let category;

  beforeEach(async () => {
    category = await Category.create({ name: "Electronics", image: "https://example.com/cat.png" });
  });

  describe("GET /categories", () => {
    it("should return all categories", async () => {
      await Category.create({ name: "Fashion", image: "https://example.com/fashion.png" });

      const res = await request(app).get("/categories");
      expect(res.status).toBe(201);
      expect(res.body.data.results).toHaveLength(2);
    });
  });

  describe("GET /categories/:id", () => {
    it("should return a category by id", async () => {
      const res = await request(app).get(`/categories/${category._id}`);
      expect(res.status).toBe(201);
      expect(res.body.data.category.name).toBe("Electronics");
    });

    it("should return 400 for invalid id", async () => {
      const res = await request(app).get("/categories/invalid-id");
      expect(res.status).toBe(400);
    });
  });
});
