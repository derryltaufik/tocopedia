require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser } = require("../helpers");

describe("User Endpoints", () => {
  let user, token;

  beforeEach(async () => {
    const result = await createTestUser({ email: "user@test.com" });
    user = result.user;
    token = result.token;
  });

  describe("GET /users", () => {
    it("should return current user", async () => {
      const res = await request(app)
        .get("/users")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.user.email).toBe("user@test.com");
    });

    it("should reject without auth", async () => {
      const res = await request(app).get("/users");
      expect(res.status).toBe(401);
    });
  });

  describe("PATCH /users", () => {
    it("should update user name", async () => {
      const res = await request(app)
        .patch("/users")
        .set("Authorization", `Bearer ${token}`)
        .send({ name: "New Name" });

      expect(res.status).toBe(200);
      expect(res.body.data.user.name).toBe("New Name");
    });

    it("should reject invalid update fields", async () => {
      const res = await request(app)
        .patch("/users")
        .set("Authorization", `Bearer ${token}`)
        .send({ email: "hacked@test.com" });

      expect(res.status).toBe(400);
    });
  });
});
