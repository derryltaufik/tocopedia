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

const { Category } = require("./models/category");
const { Product } = require("./models/product");
const { Review } = require("./models/review");

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
  await Category.insertMany([
    {
      id: 37,
      name: "Kesehatan",
      url: "https://www.tokopedia.com/p/kesehatan",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/76bd6d8e-0ea3-4700-8372-157eba990736.png",
      type: "1",
      categoryId: 715,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 65,
      name: "Perawatan Tubuh",
      url: "https://www.tokopedia.com/p/perawatan-tubuh",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/4286223b-a209-4e6d-ae27-eff5bdb910fe.png",
      type: "1",
      categoryId: 2133,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 47,
      name: "Komputer & Laptop",
      url: "https://www.tokopedia.com/p/komputer-laptop",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/b9c0139b-43f7-4a95-8b1e-ae96c9650a54.png",
      type: "1",
      categoryId: 297,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 16,
      name: "Makanan & Minuman",
      url: "https://www.tokopedia.com/p/makanan-minuman",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/c3255af6-6900-4891-8105-5663b0aabcee.png",
      type: "1",
      categoryId: 35,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 9,
      name: "Handphone & Tablet",
      url: "https://www.tokopedia.com/p/handphone-tablet",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/fd4be0d4-1eae-4d3b-b5de-3653ee47b9b1.png",
      type: "1",
      categoryId: 65,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 10,
      name: "Elektronik",
      url: "https://www.tokopedia.com/p/elektronik",
      image:
        "https://images.tokopedia.net/img/MIPuRC/2023/1/10/aaa39c11-c8ad-4f9b-8546-1069e855a585.png",
      type: "1",
      categoryId: 60,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 157,
      name: "Pertukangan",
      url: "https://www.tokopedia.com/p/pertukangan",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/e74f3cd5-fd72-4078-9cb1-86b5e4b072b4.png",
      type: "1",
      categoryId: 4029,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 40,
      name: "Dapur",
      url: "https://www.tokopedia.com/p/dapur",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/2cfdd016-0137-4f55-93b0-8a7abaee1d2f.png",
      type: "1",
      categoryId: 983,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 31,
      name: "Fashion Pria",
      url: "https://www.tokopedia.com/p/fashion-pria",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/e3292765-da49-43fa-ae15-f9265cb81334.png",
      type: "1",
      categoryId: 1759,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 32,
      name: "Fashion Muslim",
      url: "https://www.tokopedia.com/p/fashion-muslim",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/b257a219-0146-4dd1-baa7-cdaa40d45a5b.png",
      type: "1",
      categoryId: 1760,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 20,
      name: "Film & Musik",
      url: "https://www.tokopedia.com/p/film-musik",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/6/2/e8ccad4d-0f93-49ca-8ea1-f14be306357e.png",
      type: "1",
      categoryId: 57,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 55,
      name: "Gaming",
      url: "https://www.tokopedia.com/p/gaming",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/fde773cd-cb8e-4949-824c-a30f0904ce9f.png",
      type: "1",
      categoryId: 2099,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 34,
      name: "Fashion Anak & Bayi",
      url: "https://www.tokopedia.com/p/fashion-anak-bayi",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/15222c06-c537-44b0-a7fc-b15b90126b77.png",
      type: "1",
      categoryId: 78,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 30,
      name: "Fashion Wanita",
      url: "https://www.tokopedia.com/p/fashion-wanita",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/c8d73291-e084-4277-bbaf-88d86260a61a.png",
      type: "1",
      categoryId: 1758,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 12,
      name: "Kamera",
      url: "https://www.tokopedia.com/p/kamera",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/2d11f455-a696-4f81-a87a-afc8418cf4d3.png",
      type: "1",
      categoryId: 578,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 35,
      name: "Kecantikan",
      url: "https://www.tokopedia.com/p/kecantikan",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/09d3cfc8-5a55-41ac-98f7-d0c1cfb9a875.png",
      type: "1",
      categoryId: 61,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 19,
      name: "Buku",
      url: "https://www.tokopedia.com/p/buku",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/d18cb921-4c1f-423b-a095-7ba5f8b36ef6.png",
      type: "1",
      categoryId: 8,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 15,
      name: "Mainan & Hobi",
      url: "https://www.tokopedia.com/p/mainan-hobi",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/ee10f870-8830-49e7-bdaa-c3693e76d097.png",
      type: "1",
      categoryId: 55,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 79,
      name: "Rumah Tangga",
      url: "https://www.tokopedia.com/p/rumah-tangga",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/9c9c3585-f3d1-4fc5-9e8e-171942eeb43b.png",
      type: "1",
      categoryId: 984,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 28,
      name: "Office & Stationery",
      url: "https://www.tokopedia.com/p/office-stationery",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/64bc0f62-d191-45ae-9380-36436446fc15.png",
      type: "1",
      categoryId: 642,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 38,
      name: "Olahraga",
      url: "https://www.tokopedia.com/p/olahraga",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/73d58930-f346-4cfc-aeb4-783d282d4542.png",
      type: "1",
      categoryId: 62,
      __typename: "DynamicHomeCategoryRow",
    },
    {
      id: 39,
      name: "Otomotif",
      url: "https://www.tokopedia.com/p/otomotif",
      image:
        "https://images.tokopedia.net/img/cache/100-square/MIPuRC/2021/5/28/bfe66305-e038-4d69-a559-ff1d94d32051.png",
      type: "1",
      categoryId: 63,
      __typename: "DynamicHomeCategoryRow",
    },
  ]);
  res.send({ status: "success" });
});

app.get("/test/:productId", async (req, res) => {
  try {
    let product = await Product.findById(req.params.productId);
    await Review.updateProductRating(product);
    product = await Product.findById(req.params.productId);
    return res.send({ data: { product } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`server listening on port ${PORT}`);
});
