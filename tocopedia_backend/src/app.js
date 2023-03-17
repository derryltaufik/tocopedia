const express = require("express");

require("./db/mongoose");

const authRouter = require("./routers/auth");
const userRouter = require("./routers/user");
const addressRouter = require("./routers/address");
const categoryRouter = require("./routers/category");
const productRouter = require("./routers/product");
const cartRouter = require("./routers/cart");
const orderRouter = require("./routers/order");
const orderItemRouter = require("./routers/order_item");
const reviewRouter = require("./routers/review");
const wishlistRouter = require("./routers/wishlist");

const app = express();

const PORT = process.env.PORT;

app.use(express.json());
app.use(authRouter);
app.use(userRouter);
app.use(productRouter);
app.use(cartRouter);
app.use(orderRouter);
app.use(orderItemRouter);
app.use(categoryRouter);
app.use(addressRouter);
app.use(reviewRouter);
app.use(wishlistRouter);

app.get("/", async (req, res) => {
  res.send({ status: "success" });
});

app.listen(PORT, () => {
  console.log(`server listening on port ${PORT}`);
});
