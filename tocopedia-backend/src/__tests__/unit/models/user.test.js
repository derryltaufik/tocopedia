require("../../setup");
const { User } = require("../../../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

describe("User Model", () => {
  it("should hash password before saving", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();
    expect(user.password).not.toBe("password123");
    const isMatch = await bcrypt.compare("password123", user.password);
    expect(isMatch).toBe(true);
  });

  it("should not rehash password if not modified", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();
    const hashedPassword = user.password;

    user.name = "Updated";
    await user.save();
    expect(user.password).toBe(hashedPassword);
  });

  it("should generate a valid auth token", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();

    const token = await user.generateAuthToken();
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    expect(decoded._id).toBe(user._id.toString());
  });

  it("should find user by valid credentials", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();

    const found = await User.findByCredentials("test@example.com", "password123");
    expect(found._id.toString()).toBe(user._id.toString());
  });

  it("should reject invalid email", async () => {
    await expect(
      User.findByCredentials("wrong@example.com", "password123")
    ).rejects.toThrow("Email not registered");
  });

  it("should reject invalid password", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();

    await expect(
      User.findByCredentials("test@example.com", "wrongpassword")
    ).rejects.toThrow("Password incorrect");
  });

  it("should create cart and wishlist on new user", async () => {
    const { Cart } = require("../../../models/cart");
    const { UserWishlist } = require("../../../models/user_wishlist");

    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "password123",
    });
    await user.save();

    const cart = await Cart.findOne({ owner: user._id });
    const wishlist = await UserWishlist.findOne({ owner: user._id });
    expect(cart).not.toBeNull();
    expect(wishlist).not.toBeNull();
  });

  it("should reject invalid email format", async () => {
    const user = new User({
      name: "Test",
      email: "not-an-email",
      password: "password123",
    });
    await expect(user.save()).rejects.toThrow();
  });

  it("should reject short password", async () => {
    const user = new User({
      name: "Test",
      email: "test@example.com",
      password: "short",
    });
    await expect(user.save()).rejects.toThrow();
  });
});
