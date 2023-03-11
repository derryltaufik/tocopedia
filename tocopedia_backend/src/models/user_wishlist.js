const mongoose = require("mongoose");
const ObjectID = mongoose.Schema.Types.ObjectId;

const userWishlistSchema = new mongoose.Schema(
  {
    owner: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    wishlist_products: [
      {
        type: ObjectID,
        ref: "Product",
        required: true,
      },
    ],
  },
  {
    timestamps: true,
  }
);

const UserWishlist = mongoose.model("UserWishlist", userWishlistSchema);
module.exports = { UserWishlist, userWishlistSchema };
