const mongoose = require("mongoose");
const { productSchema } = require("./product");
const ObjectID = mongoose.Schema.Types.ObjectId;

const cartSchema = new mongoose.Schema(
  {
    owner: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    cart_items: [
      {
        seller: {
          type: ObjectID,
          ref: "User",
          required: true,
        },
        cart_item_details: [
          {
            product: {
              type: ObjectID,
              ref: "Product",
              required: true,
            },
            selected: {
              type: Boolean,
              default: true,
            },
            quantity: {
              type: Number,
              required: true,
              min: 1,
              default: 1,
            },
          },
        ],
      },
    ],
  },
  {
    timestamps: true,
  }
);

const Cart = mongoose.model("Cart", cartSchema);
module.exports = { Cart, cartSchema };
