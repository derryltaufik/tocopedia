const mongoose = require("mongoose");
const { categorySchema } = require("./category");
const validator = require("validator");
const ObjectID = mongoose.Schema.Types.ObjectId;

const productSchema = new mongoose.Schema(
  {
    owner: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    name: {
      type: String,
      required: true,
      trim: true,
      maxlLength: 70,
    },
    images: {
      type: [
        {
          type: String,
          required: true,
        },
      ],
      validate: [
        (val) => val.length >= 1 && val.length <= 5,
        "product must have 1 - 5 images",
      ],
    },
    price: {
      type: Number,
      required: true,
      min: 1,
    },
    stock: {
      type: Number,
      default: 1,
      min: 0,
      validate: [
        (value) => {
          return validator.isInt(value + "");
        },
        "stock must be an integer",
      ],
    },
    SKU: {
      type: String,
      required: false,
      maxlLength: 40,
    },
    description: {
      type: String,
      required: true,
      maxlLength: 2000,
    },
    status: {
      type: String,
      enum: ["active", "inactive", "banned"],
      default: "active",
    },
    category: {
      type: ObjectID,
      required: true,
      ref: "Category",
    },
    total_sold: {
      type: Number,
      default: 0,
      validate: [
        (value) => {
          return validator.isInt(value + "");
        },
        "total_sold must be an integer",
      ],
    },
    total_rating: {
      type: Number,
      required: false,
      validate: [
        (value) => {
          return validator.isInt(value + "");
        },
        "total_rating must be an integer",
      ],
    },
    average_rating: {
      type: Number,
      required: false,
      min: 0,
      max: 5,
    },
  },
  {
    timestamps: true,
  }
);

productSchema.pre("save", async function (next) {
  const product = this;
  if (product.stock == 0) {
    product.status = "inactive";
  }

  next();
});

productSchema.methods.updateRating = async function (
  rating_count,
  rating_average
) {
  const product = this;
  product.total_rating = rating_count;
  product.average_rating = rating_average;

  await product.save();
};

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };
