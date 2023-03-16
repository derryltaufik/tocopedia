const express = require("express");
const { Cart } = require("../models/cart");
const { Product } = require("../models/product");
const auth = require("../middleware/auth");
const { User } = require("../models/user");

const router = new express.Router();

//get cart products

const populateQuery = [
  {
    path: "cart_items",
    populate: [
      {
        path: "seller",
        select: "_id name",
      },
      {
        path: "cart_item_details",
        populate: {
          path: "product",
          select: "-createdAt -updatedAt -__v -owner -description",
          populate: [
            {
              path: "owner",
              select: "_id name",
            },
            {
              path: "category",
              select: "_id name",
            },
          ],
        },
      },
    ],
  },
  {
    path: "owner",
    select: "_id",
  },
];

router.get("/cart", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    let cart = await Cart.findOne({ owner });

    if (!cart) {
      cart = await Cart.create({
        owner,
        cart_items: [],
      });
    }
    await cart.populate(populateQuery);

    return res.send({ data: { cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//TODO move logic to cart's method

//add to cart
router.patch("/cart/add/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;
    const cart = await Cart.findOne({ owner });
    const product = await Product.findOne({ _id: product_id });
    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }
    // can't buy your own product
    const seller = product.owner;
    if (seller.equals(owner)) {
      return res
        .status(403)
        .send({ error: "seller can't buy their own product" });
    }

    // check if user has cart
    if (cart) {
      //search shop in cart
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
          cart_item_details: [{ product: product_id, quantity: 1 }],
        });
        await cart.save();
      }

      //if shop found but no product found
      if (shop_index != -1 && product_index == -1) {
        cart.cart_items[shop_index].cart_item_details.push({
          product: product_id,
          quantity: 1,
        });
        await cart.save();
      }

      //if product  in cart
      if (shop_index != -1 && product_index != -1) {
        let cart_item_detail =
          cart.cart_items[shop_index].cart_item_details[product_index];

        if (cart_item_detail.quantity + 1 > product.stock) {
          return res.status(400).send({ error: "product stock insufficient" });
        }
        cart_item_detail.quantity++;
        cart.cart_items[shop_index].cart_item_details[product_index] =
          cart_item_detail;
        await cart.save();
      }
    }

    //if user doesn't have cart
    if (!cart) {
      const cart = await Cart.create({
        owner,
        cart_items: [
          {
            seller,
            products: [{ product: product_id, quantity: 1 }],
          },
        ],
      });
      await cart.save();
    }
    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//remove from cart
router.patch("/cart/remove/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;
    const cart = await Cart.findOne({ owner });
    const product = await Product.findOne({ _id: product_id });

    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }
    const seller = product.owner;

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //search product in cart
    const product_index = cart.cart_items[
      shop_index
    ].cart_item_details.findIndex((cart_item_detail) =>
      cart_item_detail.product._id.equals(product._id)
    );

    if (product_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //if product in cart
    if (product_index != -1) {
      let cart_item_detail =
        cart.cart_items[product_index].cart_item_details[product_index];

      if (cart_item_detail.quantity - 1 > product.stock) {
        cart_item_detail.quantity = product.stock;
      } else {
        cart_item_detail.quantity -= 1;
      }

      if (cart_item_detail.quantity <= 0) {
        cart_item_detail.quantity = 1;
        // cart.cart_items.splice(product_index, 1);
      } else {
      }
      cart.cart_items[product_index].cart_item_details[product_index] =
        cart_item_detail;
      await cart.save();
    }
    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//update cart quantity
router.patch("/cart/update/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;
    const { quantity } = req.body;
    const cart = await Cart.findOne({ owner });
    const product = await Product.findOne({ _id: product_id });

    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }
    const seller = product.owner;

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //search product in cart
    const product_index = cart.cart_items[
      shop_index
    ].cart_item_details.findIndex((cart_item_detail) =>
      cart_item_detail.product._id.equals(product._id)
    );

    if (product_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //if product in cart
    if (product_index != -1) {
      let cart_item_detail =
        cart.cart_items[shop_index].cart_item_details[product_index];

      if (quantity <= 0) {
        cart.cart_items[shop_index].cart_item_details.splice(product_index, 1);
        if (cart.cart_items[shop_index].cart_item_details.length == 0) {
          cart.cart_items.splice(shop_index, 1);
        }
      } else {
        cart_item_detail.quantity = Math.min(quantity, product.stock);
      }
      await cart.save();
    }

    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//select all seller item
router.patch("/cart/select/seller/:seller_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const seller_id = req.params.seller_id;
    const cart = await Cart.findOne({ owner });
    const seller = await User.findOne({ _id: seller_id });

    if (!seller) {
      return res.status(404).send({ error: "product not found" });
    }

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //if product in cart
    if (shop_index != -1) {
      let cart_item_details = cart.cart_items[shop_index].cart_item_details;

      cart_item_details.forEach((cart_item) => {
        cart_item.selected = true;
      });
      await cart.save();
    }

    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//unselect all seller item
router.patch("/cart/unselect/seller/:seller_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const seller_id = req.params.seller_id;
    const cart = await Cart.findOne({ owner });
    const seller = await User.findOne({ _id: seller_id });

    if (!seller) {
      return res.status(404).send({ error: "product not found" });
    }

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //if product in cart
    if (shop_index != -1) {
      let cart_item_details = cart.cart_items[shop_index].cart_item_details;

      cart_item_details.forEach((cart_item) => {
        cart_item.selected = false;
      });
      await cart.save();
    }

    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//select cart item
router.patch("/cart/select/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;
    const cart = await Cart.findOne({ owner });
    const product = await Product.findOne({ _id: product_id });

    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }

    const seller = product.owner;

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //search product in cart
    const product_index = cart.cart_items[
      shop_index
    ].cart_item_details.findIndex((cart_item_detail) =>
      cart_item_detail.product._id.equals(product._id)
    );

    if (product_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }
    //if product in cart
    if (product_index != -1) {
      let cart_item_detail =
        cart.cart_items[shop_index].cart_item_details[product_index];

      cart_item_detail.selected = true;
      await cart.save();
    }

    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});
//unselect cart item
router.patch("/cart/unselect/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;
    const cart = await Cart.findOne({ owner });
    const product = await Product.findOne({ _id: product_id });

    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }

    const seller = product.owner;

    //search shop in cart
    const shop_index = cart.cart_items.findIndex((cart_item) =>
      cart_item.seller.equals(seller._id)
    );

    if (shop_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }

    //search product in cart
    const product_index = cart.cart_items[
      shop_index
    ].cart_item_details.findIndex((cart_item_detail) =>
      cart_item_detail.product._id.equals(product._id)
    );

    if (product_index == -1) {
      return res.status(404).send({ error: "no such product in cart" });
    }
    //if product in cart
    if (product_index != -1) {
      let cart_item_detail =
        cart.cart_items[shop_index].cart_item_details[product_index];

      cart_item_detail.selected = false;
      await cart.save();
    }

    const updated_cart = await cart.populate(populateQuery);
    return res.status(200).send({ data: { cart: updated_cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/cart/clear", auth, async (req, res) => {
  const owner = req.user._id;

  try {
    const cart = await Cart.findOne({ owner });
    cart.cart_items = [];
    await cart.save();
    return res.status(200).send({ data: { cart } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
