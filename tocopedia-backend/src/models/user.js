const mongoose = require("mongoose");
const validator = require("validator");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { addressSchema } = require("./address");
const { Cart } = require("./cart");
const { UserWishlist } = require("./user_wishlist");
const ObjectID = mongoose.Schema.Types.ObjectId;

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      maxLength: 35,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      maxLength: 100,
      validate(value) {
        if (!validator.isEmail(value + "")) {
          throw new Error("Email is invalid");
        }
      },
    },
    password: {
      type: String,
      required: true,
      minLength: 8,
      maxLength: 256,
    },

    default_address: {
      type: ObjectID,
      ref: "Address",
    },
  },
  {
    timestamps: true,
  }
);
userSchema.statics.findByCredentials = async (email, password) => {
  const user = await User.findOne({ email });
  if (!user) {
    throw new Error("Email not registered");
  }
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    throw new Error("Password incorrect");
  }
  return user;
};

userSchema.methods.generateAuthToken = async function () {
  const user = this;
  const token = jwt.sign({ _id: user._id.toString() }, process.env.JWT_SECRET);
  return token;
};

userSchema.pre("save", async function (next) {
  const user = this;
  if (user.isModified("password")) {
    user.password = await bcrypt.hash(user.password, 8);
  }
  if (this.isNew) {
    await Cart.create({
      owner: user._id,
    });
    await UserWishlist.create({
      owner: user._id,
    });
  }
  next();
});

const User = mongoose.model("User", userSchema);
module.exports = { User, userSchema };
