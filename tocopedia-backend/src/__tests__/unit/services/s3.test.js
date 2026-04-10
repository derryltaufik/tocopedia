require("../../setup");

// Mock AWS SDK modules before requiring s3 service
const mockGetSignedUrl = jest.fn();
const mockSend = jest.fn();

jest.mock("@aws-sdk/client-s3", () => {
  return {
    S3Client: jest.fn(() => ({ send: mockSend })),
    PutObjectCommand: jest.fn((params) => params),
  };
});

jest.mock("@aws-sdk/s3-request-presigner", () => ({
  getSignedUrl: mockGetSignedUrl,
}));

const {
  getPresignedUploadUrl,
  uploadFile,
  ALLOWED_MIME_TYPES,
  MAX_FILE_SIZE,
} = require("../../../services/s3");

describe("S3 Service", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    process.env.AWS_S3_BUCKET = "test-bucket";
    process.env.AWS_REGION = "us-east-1";
    delete process.env.AWS_S3_PUBLIC_URL;
    mockGetSignedUrl.mockResolvedValue("https://s3.example.com/presigned-url");
    mockSend.mockResolvedValue({});
  });

  describe("getPresignedUploadUrl", () => {
    it("should return presigned URL data for valid content type", async () => {
      const result = await getPresignedUploadUrl("image/jpeg", ".jpg");

      expect(result).toHaveProperty("presignedUrl", "https://s3.example.com/presigned-url");
      expect(result).toHaveProperty("publicUrl");
      expect(result).toHaveProperty("key");
      expect(result).toHaveProperty("expiresIn", 300);
      expect(result.key).toMatch(/^uploads\/.*\.jpg$/);
      expect(mockGetSignedUrl).toHaveBeenCalledTimes(1);
    });

    it("should reject invalid content type", async () => {
      await expect(
        getPresignedUploadUrl("text/html", ".html")
      ).rejects.toThrow("Invalid content type");
    });

    it("should reject application/pdf", async () => {
      await expect(
        getPresignedUploadUrl("application/pdf", ".pdf")
      ).rejects.toThrow("Invalid content type");
    });

    it("should handle extension without leading dot", async () => {
      const result = await getPresignedUploadUrl("image/png", "png");
      expect(result.key).toMatch(/^uploads\/.*\.png$/);
    });

    it("should handle extension with leading dot", async () => {
      const result = await getPresignedUploadUrl("image/png", ".png");
      expect(result.key).toMatch(/^uploads\/.*\.png$/);
    });

    it("should generate unique keys", async () => {
      const result1 = await getPresignedUploadUrl("image/jpeg", ".jpg");
      const result2 = await getPresignedUploadUrl("image/jpeg", ".jpg");
      expect(result1.key).not.toBe(result2.key);
    });

    it("should use AWS_S3_PUBLIC_URL when set", async () => {
      process.env.AWS_S3_PUBLIC_URL = "https://cdn.example.com";
      const result = await getPresignedUploadUrl("image/jpeg", ".jpg");
      expect(result.publicUrl).toMatch(/^https:\/\/cdn\.example\.com\/uploads\//);
    });

    it("should fall back to default S3 URL pattern", async () => {
      const result = await getPresignedUploadUrl("image/jpeg", ".jpg");
      expect(result.publicUrl).toMatch(
        /^https:\/\/test-bucket\.s3\.us-east-1\.amazonaws\.com\/uploads\//
      );
    });

    it("should accept all allowed MIME types", async () => {
      for (const mime of ALLOWED_MIME_TYPES) {
        const ext = mime.split("/")[1];
        const result = await getPresignedUploadUrl(mime, `.${ext}`);
        expect(result.presignedUrl).toBeDefined();
      }
    });
  });

  describe("uploadFile", () => {
    it("should upload file and return public URL", async () => {
      const mockFile = {
        originalname: "photo.jpg",
        buffer: Buffer.from("fake-image-data"),
        mimetype: "image/jpeg",
      };

      const url = await uploadFile(mockFile);

      expect(url).toMatch(/^https:\/\/test-bucket\.s3\.us-east-1\.amazonaws\.com\/uploads\/.*\.jpg$/);
      expect(mockSend).toHaveBeenCalledTimes(1);
    });

    it("should use AWS_S3_PUBLIC_URL when set", async () => {
      process.env.AWS_S3_PUBLIC_URL = "https://cdn.example.com";
      const mockFile = {
        originalname: "photo.png",
        buffer: Buffer.from("fake-image-data"),
        mimetype: "image/png",
      };

      const url = await uploadFile(mockFile);
      expect(url).toMatch(/^https:\/\/cdn\.example\.com\/uploads\/.*\.png$/);
    });
  });

  describe("constants", () => {
    it("should export correct ALLOWED_MIME_TYPES", () => {
      expect(ALLOWED_MIME_TYPES).toEqual([
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/webp",
      ]);
    });

    it("should export MAX_FILE_SIZE as 5MB", () => {
      expect(MAX_FILE_SIZE).toBe(5 * 1024 * 1024);
    });
  });
});
