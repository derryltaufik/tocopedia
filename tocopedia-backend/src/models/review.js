const mongoose = require("mongoose");
const validator = require("validator");
const { Product, productSchema } = require("./product");

const ObjectID = mongoose.Schema.Types.ObjectId;

//https://seller.tokopedia.com/edu/update-stok-produk/ how order & product stock is updated

const reviewSchema = new mongoose.Schema(
  {
    order_item_detail: {
      type: ObjectID,
      required: true,
      ref: "OrderItemDetail",
    },
    seller: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    buyer: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    product: {
      type: ObjectID,
      required: true,
      ref: "Product",
    },
    product_name: {
      type: String,
    },
    product_image: {
      type: String,
    },
    rating: {
      type: Number,
      required: false,
      min: 1,
      max: 5,
      validate: [
        (value) => {
          return validator.isInt(value + "");
        },
        "rating must be an integer",
      ],
    },
    images: {
      type: [
        {
          type: String,
          required: true,
        },
      ],
      validate: [(val) => val.length <= 5, "max. 5 images"],
    },
    review: {
      type: String,
      required: false,
      maxLength: 2000,
    },
    anonymous: {
      type: Boolean,
      default: false,
    },
    completed: {
      type: Boolean,
      default: false,
    },
    total_update: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);
reviewSchema.index({ product: 1, seller: 1, buyer: 1 });

reviewSchema.pre("save", async function (next) {
  const review = this;

  if (this.isNew) {
    const product = await Product.findById(review.product);
    review.product_name = product.name;
    review.product_image = product.images[0];
    next();
  } else {
    if (review.total_update > 2)
      throw Error("Review can only be changed 2 times");
    if (!review.rating) throw Error("Rating must be filled");
    review.completed = true;
    review.total_update = review.total_update + 1;

    next();
    await Review.updateProductRating(review.product);
  }
});

reviewSchema.statics.updateProductRating = async (product_id) => {
  const product = await Product.findById(product_id);
  let docs = await Review.aggregate()
    .match({ product: product._id, completed: true })
    .group({
      _id: "$product",
      rating_total: { $sum: "$rating" },
      rating_count: { $sum: 1 },
    });

  let rating_count;
  let rating_average;
  if (!docs[0]) {
    rating_count = rating_average = 0;
  } else {
    rating_count = docs[0]["rating_count"];
    rating_average = docs[0]["rating_total"] / rating_count;
  }

  await product.updateRating(rating_count, rating_average);
};

const Review = mongoose.model("Review", reviewSchema);

module.exports = { Review, reviewSchema };
