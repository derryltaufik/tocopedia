const mongoose = require("mongoose");
const { orderItemDetailSchema } = require("./order_item_detail");
const { Product } = require("./product");
const { Review } = require("./review");
const ObjectID = mongoose.Schema.Types.ObjectId;

//https://seller.tokopedia.com/edu/update-stok-produk/ how order & product stock is updated

const orderItemSchema = new mongoose.Schema(
  {
    order: {
      type: ObjectID,
      required: true,
      ref: "Order",
    },
    buyer: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    seller: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    order_item_details: [orderItemDetailSchema],
    subtotal: {
      type: Number,
      required: true,
      default: 0,
      min: 0,
    },
    quantity_total: {
      type: Number,
      required: true,
      default: 0,
      min: 0,
    },
    airwaybill: {
      type: String,
      maxLength: 30,
    },
    status: {
      type: String,
      enum: [
        "unpaid",
        "waiting confirmation",
        "processing",
        "sent",
        "arrived at destination",
        "completed",
        "refunded",
        "cancelled",
      ],
      default: "unpaid",
    },
  },
  {
    timestamps: true,
  }
);

orderItemSchema.pre("save", async function (next) {
  if (this.isNew) {
    const order_item = this;

    if (order_item.seller.equals(order_item.buyer))
      throw Error("buyer_id and seller_id must be different");

    let subtotal = 0;
    let quantity_total = 0;
    for (let order_item_detail of order_item.order_item_details) {
      subtotal += order_item_detail.product_price * order_item_detail.quantity;
      quantity_total += order_item_detail.quantity;
    }
    order_item.subtotal = subtotal;
    order_item.quantity_total = quantity_total;
  }

  if (this.isModified("status")) {
    const order_item = this;
    if (this.status == "waiting confirmation") {
      await updateProductStock(order_item);
    }
    // cancel is only for unpaid order. If user has paid, then they should cancel order item(s) individually
    else if (this.status == "refunded") {
    } else if (this.status == "completed") {
      await updateProductSold(order_item);
      await createReviewTemplate(order_item);
    }
  }

  next();
});

orderItemSchema.methods.pay = async function () {
  const order_item = this;

  const isSufficient = await isStockSufficient(order_item);
  if (isSufficient) {
    order_item.status = "waiting confirmation";
  } else {
    order_item.status = "refunded";
  }
  await order_item.save();
};

orderItemSchema.methods.cancel = async function () {
  const order_item = this;

  if (order_item.status === "unpaid") {
    order_item.status = "cancelled";
  } else if (order_item.status === "waiting confirmation") {
    order_item.status = "refunded";
  } else {
    throw Error("Order is on process and can not be cancelled");
  }
  await order_item.save();
};

orderItemSchema.methods.process = async function () {
  const order_item = this;

  if (order_item.status !== "waiting confirmation") {
    throw Error("order has been processed");
  }

  order_item.status = "processing";
  await order_item.save();
};

orderItemSchema.methods.send = async function (airwaybill) {
  if (!airwaybill) throw Error("Please input airwaybill (resi)!");

  const order_item = this;

  if (order_item.status !== "processing") {
    throw Error("order must be processed first");
  }
  order_item.airwaybill = airwaybill;
  order_item.status = "sent";
  await order_item.save();
};

orderItemSchema.methods.complete = async function () {
  const order_item = this;

  const allowed_status = ["sent", "arrived at destination"];

  if (!allowed_status.includes(order_item.status)) {
    throw Error("seller has not sent their item");
  }

  order_item.status = "completed";
  await order_item.save();
};

async function isStockSufficient(order_item) {
  for (order_item_detail of order_item.order_item_details) {
    const product = await Product.findById(order_item_detail.product);
    if (
      !(
        order_item_detail.quantity <= product.stock &&
        product.status == "active"
      )
    ) {
      return false;
    }
  }
  return true;
}

async function updateProductStock(order_item) {
  for (order_item_detail of order_item.order_item_details) {
    const product = await Product.findById(order_item_detail.product);
    product.stock -= order_item_detail.quantity;
    await product.save();
  }
  return true;
}

async function updateProductSold(order_item) {
  for (order_item_detail of order_item.order_item_details) {
    const product = await Product.findById(order_item_detail.product);
    product.total_sold += order_item_detail.quantity;
    await product.save();
  }
  return true;
}

async function createReviewTemplate(order_item) {
  for (order_item_detail of order_item.order_item_details) {
    const product = await Product.findById(order_item_detail.product);
    const review = await Review.create({
      buyer: order_item.buyer,
      seller: order_item.seller,
      product,
      order_item_detail,
      createdAt: order_item.createdAt,
      updatedAt: order_item.updatedAt,
    });
  }
}

const OrderItem = mongoose.model("OrderItem", orderItemSchema);

module.exports = { OrderItem, orderItemSchema };
