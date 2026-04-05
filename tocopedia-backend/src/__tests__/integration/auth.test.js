require("../setup");
const request = require("supertest");
const app = require("../../app");
const { User } = require("../../models/user");

describe("Auth Endpoints", () => {
  describe("POST /auth/signup", () => {
    it("should create a new user", async () => {
      const res = await request(app)
        .post("/auth/signup")
        .send({ name: "Test", email: "test@example.com", password: "password123" });

      expect(res.status).toBe(201);
      expect(res.body.data.user.email).toBe("test@example.com");
      expect(res.body.data.user.token).toBeDefined();
    });

    it("should reject duplicate email", async () => {
      await User.create({ name: "Test", email: "test@example.com", password: "password123" });

      const res = await request(app)
        .post("/auth/signup")
        .send({ name: "Test2", email: "test@example.com", password: "password123" });

      expect(res.status).toBe(400);
      expect(res.body.error).toBe("email is already used");
    });

    it("should reject invalid email", async () => {
      const res = await request(app)
        .post("/auth/signup")
        .send({ name: "Test", email: "not-email", password: "password123" });

      expect(res.status).toBe(400);
    });

    it("should reject short password", async () => {
      const res = await request(app)
        .post("/auth/signup")
        .send({ name: "Test", email: "test@example.com", password: "short" });

      expect(res.status).toBe(400);
    });
  });

  describe("POST /auth/login", () => {
    beforeEach(async () => {
      await User.create({ name: "Test", email: "test@example.com", password: "password123" });
    });

    it("should login with valid credentials", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({ email: "test@example.com", password: "password123" });

      expect(res.status).toBe(200);
      expect(res.body.data.user.token).toBeDefined();
      expect(res.body.data.user.email).toBe("test@example.com");
    });

    it("should reject wrong password", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({ email: "test@example.com", password: "wrongpassword" });

      expect(res.status).toBe(400);
    });

    it("should reject non-existent email", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({ email: "nobody@example.com", password: "password123" });

      expect(res.status).toBe(400);
    });
  });
});
