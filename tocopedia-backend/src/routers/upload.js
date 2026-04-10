const express = require("express");
const rateLimit = require("express-rate-limit");
const auth = require("../middleware/auth");
const {
  getPresignedUploadUrl,
  ALLOWED_MIME_TYPES,
  MAX_FILE_SIZE,
} = require("../services/s3");

const router = new express.Router();

const uploadLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  keyGenerator: (req) => req.user._id.toString(),
  message: { error: "Too many uploads, please try again later" },
});

router.get("/upload/presign", auth, uploadLimiter, async (req, res) => {
  try {
    const { contentType, extension } = req.query;

    if (!contentType || !extension) {
      return res
        .status(400)
        .send({ error: "contentType and extension query params are required" });
    }

    const result = await getPresignedUploadUrl(contentType, extension);
    return res.status(200).send({
      data: {
        presignedUrl: result.presignedUrl,
        publicUrl: result.publicUrl,
        key: result.key,
        expiresIn: result.expiresIn,
        maxFileSize: MAX_FILE_SIZE,
      },
    });
  } catch (error) {
    if (error.message.includes("Invalid content type")) {
      return res.status(400).send({ error: error.message });
    }
    return res
      .status(500)
      .send({ error: "Failed to generate upload URL" });
  }
});

module.exports = router;
