require("../../setup");
const { Address } = require("../../../models/address");
const { User } = require("../../../models/user");

let user;

beforeEach(async () => {
  user = await User.create({
    name: "Test",
    email: "test@example.com",
    password: "password123",
  });
});

describe("Address Model - Phone Normalization", () => {
  it("should normalize 08xx to +628xx", async () => {
    const address = await Address.create({
      owner: user._id,
      complete_address: "Jl. Test No. 1",
      receiver_name: "Test",
      receiver_phone: "081234567890",
    });
    expect(address.receiver_phone).toBe("+6281234567890");
  });

  it("should normalize 628xx to +628xx", async () => {
    const address = await Address.create({
      owner: user._id,
      complete_address: "Jl. Test No. 1",
      receiver_name: "Test",
      receiver_phone: "6281234567890",
    });
    expect(address.receiver_phone).toBe("+6281234567890");
  });

  it("should keep +628xx as is", async () => {
    const address = await Address.create({
      owner: user._id,
      complete_address: "Jl. Test No. 1",
      receiver_name: "Test",
      receiver_phone: "+6281234567890",
    });
    expect(address.receiver_phone).toBe("+6281234567890");
  });

  it("should strip dashes and spaces", async () => {
    const address = await Address.create({
      owner: user._id,
      complete_address: "Jl. Test No. 1",
      receiver_name: "Test",
      receiver_phone: "0812-3456-7890",
    });
    expect(address.receiver_phone).toBe("+6281234567890");
  });
});
