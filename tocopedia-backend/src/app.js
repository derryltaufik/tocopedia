const express = require("express");
const cors = require("cors");

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
const uploadRouter = require("./routers/upload");
const wishlistRouter = require("./routers/wishlist");

const app = express();

app.use(cors());
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
app.use(uploadRouter);
app.use(wishlistRouter);

app.get("/", async (req, res) => {
  res.send({ status: "success" });
});

if (require.main === module) {
  const PORT = process.env.PORT;
  app.listen(PORT, () => {
    console.log(`server listening on port ${PORT}`);
  });
}

module.exports = app;
