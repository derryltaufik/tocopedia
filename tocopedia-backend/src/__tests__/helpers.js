const { User } = require("../models/user");
const { Category } = require("../models/category");
const { Product } = require("../models/product");
const { Address } = require("../models/address");
const jwt = require("jsonwebtoken");

let counter = 0;

const createTestUser = async (overrides = {}) => {
  counter++;
  const user = new User({
    name: `Test User ${counter}`,
    email: `test${counter}@example.com`,
    password: "password123",
    ...overrides,
  });
  await user.save();
  const token = await user.generateAuthToken();
  return { user, token };
};

const createCategory = async (overrides = {}) => {
  counter++;
  return Category.create({
    name: `Category ${counter}`,
    image: `https://example.com/cat${counter}.png`,
    ...overrides,
  });
};

const createProduct = async (owner, category, overrides = {}) => {
  const product = new Product({
    owner: owner._id,
    name: `Product ${counter++}`,
    images: ["https://example.com/img.png"],
    price: 10000,
    stock: 10,
    description: "Test product description",
    category: category._id,
    ...overrides,
  });
  await product.save();
  return product;
};

const createAddress = async (owner, overrides = {}) => {
  return Address.create({
    owner: owner._id,
    label: "Home",
    complete_address: "Jl. Test No. 123, Jakarta",
    receiver_name: "Test Receiver",
    receiver_phone: "081234567890",
    ...overrides,
  });
};

module.exports = {
  createTestUser,
  createCategory,
  createProduct,
  createAddress,
};
