require("../../setup");
const { Product } = require("../../../models/product");
const { User } = require("../../../models/user");
const { Category } = require("../../../models/category");
const mongoose = require("mongoose");

let user, category;

beforeEach(async () => {
  user = await User.create({
    name: "Seller",
    email: "seller@example.com",
    password: "password123",
  });
  category = await Category.create({
    name: "Electronics",
    image: "https://example.com/cat.png",
  });
});

describe("Product Model", () => {
  it("should set status to inactive when stock is 0", async () => {
    const product = new Product({
      owner: user._id,
      name: "Test Product",
      images: ["https://example.com/img.png"],
      price: 10000,
      stock: 0,
      description: "A test product",
      category: category._id,
    });
    await product.save();
    expect(product.status).toBe("inactive");
  });

  it("should keep status active when stock > 0", async () => {
    const product = new Product({
      owner: user._id,
      name: "Test Product",
      images: ["https://example.com/img.png"],
      price: 10000,
      stock: 5,
      description: "A test product",
      category: category._id,
    });
    await product.save();
    expect(product.status).toBe("active");
  });

  it("should update rating via updateRating method", async () => {
    const product = new Product({
      owner: user._id,
      name: "Test Product",
      images: ["https://example.com/img.png"],
      price: 10000,
      stock: 5,
      description: "A test product",
      category: category._id,
    });
    await product.save();

    await product.updateRating(10, 4.5);
    expect(product.total_rating).toBe(10);
    expect(product.average_rating).toBe(4.5);
  });

  it("should reject product without images", async () => {
    const product = new Product({
      owner: user._id,
      name: "Test Product",
      images: [],
      price: 10000,
      stock: 5,
      description: "A test product",
      category: category._id,
    });
    await expect(product.save()).rejects.toThrow();
  });

  it("should reject product with price < 1", async () => {
    const product = new Product({
      owner: user._id,
      name: "Test Product",
      images: ["https://example.com/img.png"],
      price: 0,
      stock: 5,
      description: "A test product",
      category: category._id,
    });
    await expect(product.save()).rejects.toThrow();
  });
});
