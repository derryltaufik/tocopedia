const express = require("express");
const rateLimit = require("express-rate-limit");
const auth = require("../middleware/auth");
const upload = require("../middleware/upload");
const { uploadFile } = require("../services/s3");

const router = new express.Router();

const uploadLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 30, // 30 uploads per 15 min per user
  keyGenerator: (req) => req.user._id.toString(),
  message: { error: "Too many uploads, please try again later" },
});

router.post(
  "/upload",
  auth,
  uploadLimiter,
  upload.single("image"),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).send({ error: "No image file provided" });
      }

      const url = await uploadFile(req.file);
      return res.status(201).send({ data: { url } });
    } catch (error) {
      return res.status(400).send({ error: error.message });
    }
  }
);

module.exports = router;
