const express = require("express");
const auth = require("../middleware/auth");
const { OrderItem } = require("../models/order_item");

const router = new express.Router();

const populateQuery = [
  {
    path: "order",
    select: "_id address createdAt",
  },
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
];

const populateQuerySingleItem = [
  {
    path: "order",
    select: "_id address createdAt",
  },
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
];

//get order_items

router.get("/order-items/seller", auth, async (req, res) => {
  try {
    const seller = req.user._id;

    const order_items = await OrderItem.find({
      seller,
      status: { $ne: "cancelled" },
    })
      .sort({ createdAt: -1 })
      .populate(populateQuery);

    if (order_items) {
      return res.status(200).send({ data: { results: order_items } });
    }
    return res.status(404).send("No order_items found");
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/order-items/buyer", auth, async (req, res) => {
  try {
    const buyer = req.user._id;

    const order_items = await OrderItem.find({
      buyer,
      status: { $ne: "unpaid" },
    })
      .sort({ createdAt: -1 })
      .populate(populateQuery);
    if (order_items) {
      return res.status(200).send({ data: { results: order_items } });
    }
    return res.status(404).send("No order_items found");
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/order-items/:id", auth, async (req, res) => {
  try {
    const order_item = await OrderItem.findById(req.params.id).populate(
      populateQuerySingleItem
    );

    if (!order_item) {
      return res.status(404).send("No order_item found");
    }

    if (
      !(
        order_item.seller.equals(req.user._id) ||
        order_item.buyer.equals(req.user._id)
      )
    ) {
      return res
        .status(403)
        .send({ error: "you are not allowed to access this order_item" });
    }
    return res.status(200).send({ data: { order_item } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//buyer or seller cancel before seller process
router.patch("/order-items/:id/cancel", auth, async (req, res) => {
  try {
    const order_item = await OrderItem.findById(req.params.id);

    if (!order_item) {
      return res.status(404).send("No order_item found");
    }

    if (
      !(
        order_item.seller.equals(req.user._id) ||
        order_item.buyer.equals(req.user._id)
      )
    ) {
      return res
        .status(403)
        .send({ error: "only seller or buyer can process this order_item" });
    }

    await order_item.cancel();
    const updated_order_item = await order_item.populate(populateQuery);
    return res.status(200).send({ data: { order_item: updated_order_item } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

//seller processing the order
router.patch("/order-items/:id/process", auth, async (req, res) => {
  try {
    const order_item = await OrderItem.findById(req.params.id);

    if (!order_item) {
      return res.status(404).send("No order_item found");
    }

    if (!order_item.seller.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "only seller can process this order_item" });
    }

    await order_item.process();
    const updated_order_item = await order_item.populate(populateQuery);
    return res.status(200).send({ data: { order_item: updated_order_item } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});
//seller sending the order
router.patch("/order-items/:id/send", auth, async (req, res) => {
  try {
    const { airwaybill } = req.body;

    const order_item = await OrderItem.findById(req.params.id);

    if (!order_item) {
      return res.status(404).send("No order_item found");
    }

    if (!order_item.seller.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "only seller can send this order_item" });
    }

    await order_item.send(airwaybill);
    const updated_order_item = await order_item.populate(populateQuery);
    return res.status(200).send({ data: { order_item: updated_order_item } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/order-items/:id/complete", auth, async (req, res) => {
  try {
    const order_item = await OrderItem.findById(req.params.id);

    if (!order_item) {
      return res.status(404).send("No order_item found");
    }

    if (!order_item.buyer.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "only buyer can complete this order_item" });
    }

    await order_item.complete();
    const updated_order_item = await order_item.populate(populateQuery);
    return res.status(200).send({ data: { order_item: updated_order_item } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
