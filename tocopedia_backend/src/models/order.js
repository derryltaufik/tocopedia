const mongoose = require("mongoose");
const { addressSchema } = require("./address");
const { orderItemSchema, OrderItem } = require("./order_item");
const { Product } = require("./product");
const ObjectID = mongoose.Schema.Types.ObjectId;

//https://seller.tokopedia.com/edu/update-stok-produk/ how order & product stock is updated

const orderSchema = new mongoose.Schema(
  {
    owner: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    order_items: [
      {
        type: ObjectID,
        required: true,
        ref: "OrderItem",
      },
    ],
    cover_image: {
      type: String,
      default: "",
    },
    total_price: {
      type: Number,
      required: true,
      default: 0,
    },
    total_quantity: {
      type: Number,
      required: true,
      default: 0,
    },
    address: {
      complete_address: {
        type: String,
        required: true,
        maxLength: 200,
      },
      notes: {
        type: String,
        required: false,
        maxLength: 45,
      },
      receiver_name: {
        type: String,
        required: true,
        maxLength: 50,
      },
      receiver_phone: {
        type: String,
        required: true,
        maxLength: 15,
      },
    },
    status: {
      type: String,
      enum: ["unpaid", "paid", "cancelled", "expired"],
      default: "unpaid",
    },
  },
  {
    timestamps: true,
  }
);

orderSchema.pre("save", async function (next) {
  if (this.isNew || this.total_price == 0) {
    order = this;

    let total_price = 0;
    let total_quantity = 0;

    let cover_image;
    for (order_item_id of order.order_items) {
      const order_item = await OrderItem.findById(order_item_id);
      if (!cover_image)
        cover_image = order_item.order_item_details[0].product_image;
      total_price += order_item.subtotal;
      total_quantity += order_item.quantity_total;
    }
    order.total_price = total_price;
    order.total_quantity = total_quantity;
    order.cover_image = cover_image;
  }
  if (this.isModified("status")) {
    const order = this;
    //when order is paid, change all order_item status to waiting confirmation
    //however, if any product stock is insufficient, change order_item status to cancelled
    if (this.status == "paid") {
      for (order_item of order.order_items) {
        order_item_doc = await OrderItem.findById(order_item);
        await order_item_doc.pay();
      }
    }
    // cancel is only for unpaid order. If user has paid, then they should cancel order item(s) individually
    else if (this.status == "cancelled") {
      for (order_item of order.order_items) {
        order_item_doc = await OrderItem.findById(order_item);
        await order_item_doc.cancel();
      }
    }
  }
  next();
});

orderSchema.methods.pay = async function () {
  const order = this;
  order.status = "paid";
  await order.save();
};

orderSchema.methods.cancel = async function () {
  const order = this;
  if (order.status != "unpaid")
    throw Error("only unpaid order can be cancelled");

  order.status = "cancelled";
  await order.save();
};

const Order = mongoose.model("Order", orderSchema);

module.exports = { Order, orderSchema };
