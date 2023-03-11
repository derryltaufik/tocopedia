const express = require("express");
const { Order } = require("../models/order");
const { Cart } = require("../models/cart");
const auth = require("../middleware/auth");
const { Product } = require("../models/product");
const { OrderItem } = require("../models/order_item");
const { Address } = require("../models/address");
const { OrderItemDetail } = require("../models/order_item_detail");

const router = new express.Router();

const populateQuery = [
  {
    path: "owner",
    select: "_id name",
  },
  {
    path: "order_items",
    select: "-order",
    populate: [
      {
        path: "buyer",
        select: "_id name",
      },
      {
        path: "seller",
        select: "_id name",
      },
      {
        path: "order_item_details.product",
        select: "_id",
      },
    ],
  },
];

const selectQuery = {
  // address: 1,
};
//get orders

router.get("/orders", auth, async (req, res) => {
  try {
    const owner = req.user._id;

    const orders = await Order.find({ owner: owner, status: "unpaid" })
      .sort({ createdAt: -1 })
      .populate(populateQuery);
    if (orders) {
      return res.status(200).send({ data: { results: orders } });
    }
    return res.status(404).send("No orders found");
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/orders/:order_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;

    const order = await Order.findOne({
      owner: owner,
      _id: req.params.order_id,
    })
      .populate(populateQuery)
      .select(selectQuery);
    if (order) {
      return res.status(200).send({ data: { order } });
    }
    return res.status(404).send({ error: "No orders found" });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//checkout
router.post("/orders/checkout", auth, async (req, res) => {
  try {
    const user = req.user;
    const owner = user._id;

    const address = await Address.findById(req.body.address);

    if (!address) {
      return res.status(404).send({ error: "No address found" });
    }

    //find cart and user
    const cart = await Cart.findOne({ owner });
    const checkout_cart = cart.toObject();

    if (!cart) {
      return res.status(404).send({ error: "No cart found" });
    }

    // find and left behind unselected cart item
    for (var i in cart.cart_items) {
      cart.cart_items[i].cart_item_details = cart.cart_items[
        i
      ].cart_item_details.filter(
        (cart_item_detail) => !cart_item_detail.selected
      );
    }
    cart.cart_items = cart.cart_items.filter((cart_item) => {
      return cart_item.cart_item_details.length > 0;
    });

    // find selected item and continue
    for (var i in checkout_cart.cart_items) {
      checkout_cart.cart_items[i].cart_item_details = checkout_cart.cart_items[
        i
      ].cart_item_details.filter(
        (cart_item_detail) => cart_item_detail.selected
      );
    }
    checkout_cart.cart_items = checkout_cart.cart_items.filter((cart_item) => {
      return cart_item.cart_item_details.length > 0;
    });

    const cart_items = checkout_cart.cart_items;

    //ensure at least 1 product for checkout
    if (cart_items.length == 0) {
      return res
        .status(404)
        .send({ error: "No product selected for checkout" });
    }

    // create blank order to get orderId;
    let order = new Order({ owner, address });

    // create order items
    try {
      const order_item_list = [];

      for (const cart_item of cart_items) {
        const order_item_details = [];
        for (const cart_item_detail of cart_item.cart_item_details) {
          const product = await Product.findById(cart_item_detail.product);

          //ensure order quantity <= product stock
          if (cart_item_detail.quantity > product.stock) {
            throw Error(
              `${product.name} cart quantity (${cart_item_detail.quantity}) is greater than the product's stock (${product.stock})`
            );
          }
          const order_item_detail = new OrderItemDetail({
            seller: cart_item.seller,
            product,
            product_name: product.name,
            product_price: product.price,
            product_image: product.images[0],
            quantity: cart_item_detail.quantity,
          });
          await order_item_detail.save();

          order_item_details.push(order_item_detail);
        }
        const order_item = new OrderItem({
          order: order._id,
          buyer: user._id,
          seller: cart_item.seller,
          order_item_details,
        });
        await order_item.save();
        order_item_list.push(order_item._id);
      }

      order.order_items = order_item_list;

      await order.save();
      await cart.save();
    } catch (e) {
      throw Error(e.message);
    }
    const updated_order = await Order.findById(order._id).populate(
      populateQuery
    );
    return res.status(201).send({ data: { order: updated_order } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//pay
router.patch("/orders/:order_id/pay", auth, async (req, res) => {
  try {
    const order = await Order.findById(req.params.order_id);

    if (!order) {
      return res.status(404).send({ error: "order not found" });
    }

    if (!order.owner.equals(req.user._id)) {
      return res.status(403).send({ error: "only buyer can pay this order" });
    }

    await order.pay();
    const updated_order = await Order.findById(order._id).populate(
      populateQuery
    );
    return res.send({ data: { order: updated_order } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/orders/:order_id/cancel", auth, async (req, res) => {
  try {
    const order = await Order.findById(req.params.order_id);

    if (!order) {
      return res.status(404).send({ error: "order not found" });
    }

    if (!order.owner.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "only buyer can cancel this order" });
    }

    await order.cancel();
    const updated_order = await Order.findById(order._id).populate(
      populateQuery
    );
    return res.send({ data: { order: updated_order } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
