const mongoose = require("mongoose");
const ObjectID = mongoose.Schema.Types.ObjectId;

//https://seller.tokopedia.com/edu/update-stok-produk/ how order & product stock is updated

const orderItemDetailSchema = new mongoose.Schema({
  product: {
    type: ObjectID,
    ref: "Product",
    required: true,
  },
  //below are product details on transaction time;
  product_name: {
    type: String,
    required: true,
  },
  product_price: {
    type: Number,
    required: true,
    min: 1,
  },
  product_image: {
    type: String,
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
    default: 1,
  },
});

const OrderItemDetail = mongoose.model(
  "OrderItemDetail",
  orderItemDetailSchema
);

module.exports = { OrderItemDetail, orderItemDetailSchema };
