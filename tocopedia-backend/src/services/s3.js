const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
const crypto = require("crypto");

const config = {
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
};

if (process.env.AWS_ENDPOINT_URL) {
  config.endpoint = process.env.AWS_ENDPOINT_URL;
  config.forcePathStyle = true;
}

// requestChecksumCalculation disabled so the presigned URL doesn't embed
// a CRC32 checksum (which would be computed for an empty body and fail
// when the client uploads the real file).
const presignConfig = { ...config, requestChecksumCalculation: "WHEN_REQUIRED" };
if (process.env.AWS_S3_PRESIGN_ENDPOINT) {
  presignConfig.endpoint = process.env.AWS_S3_PRESIGN_ENDPOINT;
  presignConfig.forcePathStyle = true;
}
const s3Presign = new S3Client(presignConfig);

const ALLOWED_MIME_TYPES = [
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
];

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const PRESIGN_EXPIRES_IN = 300; // 5 minutes

const getPresignedUploadUrl = async (contentType, fileExtension) => {
  if (!ALLOWED_MIME_TYPES.includes(contentType)) {
    throw new Error(
      `Invalid content type. Allowed: ${ALLOWED_MIME_TYPES.join(", ")}`
    );
  }

  const ext = fileExtension.startsWith(".") ? fileExtension : `.${fileExtension}`;
  const key = `uploads/${crypto.randomUUID()}${ext}`;

  const command = new PutObjectCommand({
    Bucket: process.env.AWS_S3_BUCKET,
    Key: key,
    ContentType: contentType,
  });

  const presignedUrl = await getSignedUrl(s3Presign, command, {
    expiresIn: PRESIGN_EXPIRES_IN,
    signableHeaders: new Set(["content-type"]),
  });

  const baseUrl =
    process.env.AWS_S3_PUBLIC_URL ||
    `https://${process.env.AWS_S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com`;
  const publicUrl = `${baseUrl}/${key}`;

  return { presignedUrl, publicUrl, key, expiresIn: PRESIGN_EXPIRES_IN };
};

module.exports = {
  getPresignedUploadUrl,
  ALLOWED_MIME_TYPES,
  MAX_FILE_SIZE,
};
