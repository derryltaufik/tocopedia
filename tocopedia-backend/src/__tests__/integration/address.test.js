require("../setup");
const request = require("supertest");
const app = require("../../app");
const { createTestUser, createAddress } = require("../helpers");
const mongoose = require("mongoose");

describe("Address Endpoints", () => {
  let user, token;

  beforeEach(async () => {
    const result = await createTestUser({ email: "user@test.com" });
    user = result.user;
    token = result.token;
  });

  describe("POST /addresses", () => {
    it("should create an address", async () => {
      const res = await request(app)
        .post("/addresses")
        .set("Authorization", `Bearer ${token}`)
        .send({
          label: "Office",
          complete_address: "Jl. Sudirman No. 1, Jakarta",
          receiver_name: "John",
          receiver_phone: "081234567890",
        });

      expect(res.status).toBe(201);
      expect(res.body.data.address.label).toBe("Office");
      expect(res.body.data.address.receiver_phone).toBe("+6281234567890");
    });
  });

  describe("GET /addresses", () => {
    it("should return user addresses", async () => {
      await createAddress(user);
      await createAddress(user, { label: "Office", receiver_phone: "081234567891" });

      const res = await request(app)
        .get("/addresses")
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.results).toHaveLength(2);
    });
  });

  describe("GET /addresses/:id", () => {
    it("should return address by id", async () => {
      const address = await createAddress(user);

      const res = await request(app)
        .get(`/addresses/${address._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.address.label).toBe("Home");
    });

    it("should not return another user's address", async () => {
      const { user: otherUser } = await createTestUser({ email: "other@test.com" });
      const address = await createAddress(otherUser);

      const res = await request(app)
        .get(`/addresses/${address._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(404);
    });
  });

  describe("PATCH /addresses/:id", () => {
    it("should update address", async () => {
      const address = await createAddress(user);

      const res = await request(app)
        .patch(`/addresses/${address._id}`)
        .set("Authorization", `Bearer ${token}`)
        .send({ label: "New Label" });

      expect(res.status).toBe(200);
      expect(res.body.data.address.label).toBe("New Label");
    });
  });

  describe("DELETE /addresses/:id", () => {
    it("should delete address", async () => {
      const address = await createAddress(user);

      const res = await request(app)
        .delete(`/addresses/${address._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(200);
    });

    it("should not delete default address", async () => {
      const address = await createAddress(user);
      user.default_address = address._id;
      await user.save();

      const res = await request(app)
        .delete(`/addresses/${address._id}`)
        .set("Authorization", `Bearer ${token}`);

      expect(res.status).toBe(403);
    });
  });
});
