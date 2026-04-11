require("../setup");
const request = require("supertest");
const { createTestUser } = require("../helpers");

// Mock S3 service
jest.mock("../../services/s3", () => ({
  getPresignedUploadUrl: jest.fn().mockResolvedValue({
    presignedUrl: "https://s3.example.com/presigned-url",
    publicUrl: "https://cdn.example.com/uploads/test.jpg",
    key: "uploads/test.jpg",
    expiresIn: 300,
  }),
  ALLOWED_MIME_TYPES: ["image/jpeg", "image/png", "image/gif", "image/webp"],
  MAX_FILE_SIZE: 5 * 1024 * 1024,
}));

const app = require("../../app");
const s3Service = require("../../services/s3");

describe("Upload Endpoints", () => {
  let token;

  beforeEach(async () => {
    jest.clearAllMocks();
    const result = await createTestUser();
    token = result.token;
  });

  describe("GET /upload/presign", () => {
    it("should return presigned URL data for valid request", async () => {
      const res = await request(app)
        .get("/upload/presign")
        .set("Authorization", `Bearer ${token}`)
        .query({ contentType: "image/jpeg", extension: ".jpg" });

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty("presignedUrl");
      expect(res.body.data).toHaveProperty("publicUrl");
      expect(res.body.data).toHaveProperty("key");
      expect(res.body.data).toHaveProperty("expiresIn", 300);
      expect(res.body.data).toHaveProperty("maxFileSize", 5 * 1024 * 1024);
      expect(s3Service.getPresignedUploadUrl).toHaveBeenCalledWith("image/jpeg", ".jpg");
    });

    it("should return 400 when contentType is missing", async () => {
      const res = await request(app)
        .get("/upload/presign")
        .set("Authorization", `Bearer ${token}`)
        .query({ extension: ".jpg" });

      expect(res.status).toBe(400);
      expect(res.body.error).toMatch(/contentType/);
    });

    it("should return 400 when extension is missing", async () => {
      const res = await request(app)
        .get("/upload/presign")
        .set("Authorization", `Bearer ${token}`)
        .query({ contentType: "image/jpeg" });

      expect(res.status).toBe(400);
      expect(res.body.error).toMatch(/extension/);
    });

    it("should return 400 for invalid content type", async () => {
      s3Service.getPresignedUploadUrl.mockRejectedValueOnce(
        new Error("Invalid content type. Allowed: image/jpeg, image/png, image/gif, image/webp")
      );

      const res = await request(app)
        .get("/upload/presign")
        .set("Authorization", `Bearer ${token}`)
        .query({ contentType: "application/pdf", extension: ".pdf" });

      expect(res.status).toBe(400);
      expect(res.body.error).toMatch(/Invalid content type/);
    });

    it("should return 401 without auth token", async () => {
      const res = await request(app)
        .get("/upload/presign")
        .query({ contentType: "image/jpeg", extension: ".jpg" });

      expect(res.status).toBe(401);
    });

    it("should return 500 when S3 service fails unexpectedly", async () => {
      s3Service.getPresignedUploadUrl.mockRejectedValueOnce(
        new Error("S3 connection error")
      );

      const res = await request(app)
        .get("/upload/presign")
        .set("Authorization", `Bearer ${token}`)
        .query({ contentType: "image/jpeg", extension: ".jpg" });

      expect(res.status).toBe(500);
      expect(res.body.error).toBe("Failed to generate upload URL");
    });
  });
});
