const mongoose = require("mongoose");
const { MongoMemoryServer } = require("mongodb-memory-server");

// Set env vars synchronously so they're available when app.js is required
process.env.JWT_SECRET = "test-jwt-secret";
process.env.PORT = "3000";

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();
  process.env.MONGODB_URL = uri;

  // Disconnect default connection (db/mongoose.js may have tried to connect with undefined URL)
  if (mongoose.connection.readyState !== 0) {
    await mongoose.disconnect();
  }

  await mongoose.connect(uri);
});

afterAll(async () => {
  await mongoose.disconnect();
  if (mongoServer) await mongoServer.stop();
});

afterEach(async () => {
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    await collections[key].deleteMany({});
  }
});
