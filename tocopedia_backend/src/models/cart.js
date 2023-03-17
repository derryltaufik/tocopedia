const mongoose = require("mongoose");
const { productSchema, Product } = require("./product");
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

cartSchema.methods.addToCart = async function (product) {
  const cart = this;
  try {
    const seller = product.owner;

    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );
    //search product in cart
    const product_index =
      shop_index == -1
        ? -1
        : cart.cart_items[shop_index].cart_item_details.findIndex(
            (cart_item_detail) =>
              cart_item_detail.product._id.equals(product._id)
          );

    //if no shop & no product found
    if (shop_index == -1) {
      cart.cart_items.push({
        seller,
        cart_item_details: [{ product, quantity: 1 }],
      });
      await cart.save();
    }

    //if shop found but no product found
    if (shop_index != -1 && product_index == -1) {
      cart.cart_items[shop_index].cart_item_details.push({
        product,
        quantity: 1,
      });
      await cart.save();
    }

    //if product  in cart
    if (shop_index != -1 && product_index != -1) {
      let cart_item_detail =
        cart.cart_items[shop_index].cart_item_details[product_index];

      if (cart_item_detail.quantity + 1 > product.stock) {
        throw Error("product stock insufficient");
      }
      cart_item_detail.quantity++;
      cart.cart_items[shop_index].cart_item_details[product_index] =
        cart_item_detail;
      await cart.save();
    }
    return cart;
  } catch (error) {
    throw error;
  }
};

const Cart = mongoose.model("Cart", cartSchema);
module.exports = { Cart, cartSchema };
