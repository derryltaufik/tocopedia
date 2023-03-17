const mongoose = require("./db/mongoose");

const { Category } = require("./models/category");
const { User } = require("./models/user");
const { Product } = require("./models/product");
const { Review } = require("./models/review");

const products = require("./dummy_starter_data/products.json");
const categories = require("./dummy_starter_data/categories.json");
const users = require("./dummy_starter_data/users.json");
const reviews = require("./dummy_starter_data/reviews.json");
const category_to_user = require("./dummy_starter_data/categories_to_user.json");

const { faker } = require("@faker-js/faker/locale/id_ID");
const { Cart } = require("./models/cart");
const { UserWishlist } = require("./models/user_wishlist");
const { Address } = require("./models/address");
const { OrderItemDetail } = require("./models/order_item_detail");
const { OrderItem } = require("./models/order_item");
const { Order } = require("./models/order");
const fs = require("fs");
const random = require("./dummy_starter_data/random");

async function initCategory(existing_categories) {
  const new_categories = categories.map((e) => {
    return {
      ...e,
      image: e.imageUrl,
    };
  });
  for (const category of new_categories) {
    const not_exist =
      existing_categories.filter((e) => e.name == category.name).length == 0;
    if (not_exist) {
      try {
        await Category.create(category);
      } catch (e) {
        console.log(e);
      }
    }
  }
}

const getDummyUsers = (total_users) => {
  const users = [];

  for (let i = 0; i < total_users; i++) {
    const user = {
      name: faker.name.fullName(),
      email: `dummyuser${i}@example.com`,
      password: faker.internet.password(),
    };
    users.push(user);
  }
  return users;
};

async function initUser(existing_users) {
  existing_users = new Set(existing_users.map((e) => e.email));
  for (const user of users) {
    const exist = existing_users.has(user.email);
    if (exist) continue;
    try {
      await User.create(user);
    } catch (e) {
      console.log(e);
    }
  }
  const dummy_users = getDummyUsers(1000);
  const avaialble_dummy_users = [];
  for (const user of dummy_users) {
    const exist = existing_users.has(user.email);
    if (exist) continue;
    avaialble_dummy_users.push(user);
  }
  try {
    await User.create(avaialble_dummy_users);
  } catch (e) {
    console.log(e);
  }
}

async function initProduct(db_categories, db_users, db_products) {
  const dummyToDbCategory = new Map();
  for (let i = 0; i < categories.length; i++) {
    dummyToDbCategory.set(categories[i].categoryId, db_categories[i]);
  }

  for (const product of products) {
    const exist = db_products.filter((e) => e.name == product.name).length > 0;
    if (exist) continue;

    const category = dummyToDbCategory.get(parseInt(product.category));
    const shop_names = category_to_user[category.name];
    const shop_name = shop_names[product.tokopedia_id % shop_names.length];
    const owner = db_users.filter((e) => e.name === shop_name)[0];

    const description =
      product.description != null && product.description.length != 0
        ? product.description
        : "no description"; //some product might have empty description

    try {
      await Product.create({
        category: category,
        name: product.name,
        owner: owner,
        images: product.images.slice(0, 5),
        price: product.price,
        stock: product.stock,
        average_rating: product.average_rating,
        total_rating: product.total_rating,
        total_sold: product.total_sold,
        description: description,
      });
    } catch (e) {
      console.log(e);
    }
  }
}

async function initReviews(db_users, db_products, db_reviews) {
  const null_id = new mongoose.Types.ObjectId("000000000000000000000000");
  const available_buyers = db_users.filter((e) =>
    e.email.includes("dummyuser")
  );
  const reviews_set = new Set(db_reviews.map((e) => `${e.createdAt}`));

  const reviews_to_add = [];
  let count = 0;
  for (const [product_id, product_reviews] of Object.entries(reviews)) {
    const product = products.filter((e) => e.tokopedia_id == product_id)[0];
    if (!product) continue;
    const product_db = db_products.filter((e) => e.name == product.name)[0];
    if (!product_db) continue;

    for (const review of product_reviews) {
      const date = new Date(review.createdAt * 1000);

      const found = reviews_set.has(`${date}`);

      if (found) {
        continue;
      }

      const new_review = {
        ...review,
        review: review.review.slice(0, 2000),
        createdAt: date,
        updatedAt: date,
        buyer: available_buyers[review.review_id % available_buyers.length],
        order_item_detail: null_id,
        product: product_db._id,
        seller: product_db.owner,
        // product_name: product_db.name,
        // product_image: product_db.images[0],
        completed: true,
        total_update: 1,
      };
      reviews_to_add.push(new_review);
      count++;
    }
  }
  console.log(count);
  try {
    await Review.create(reviews_to_add);
  } catch (e) {
    console.log(e);
  }
}

const getDummyAddresses = (total_addresses) => {
  const addresses = [];
  const labels = [
    "Home",
    "Apartment",
    "Uncle Bob's House",
    "Second Home",
    "Mom",
  ];

  for (let i = 0; i < total_addresses; i++) {
    const address = {
      label: labels[i % labels.length],
      complete_address: faker.address.streetAddress(true),
      notes: faker.helpers.fake(
        "{{address.direction}} of {{address.secondaryAddress}}"
      ),
      receiver_name: faker.name.fullName(),
      receiver_phone: faker.phone.number("0815########"),
    };
    addresses.push(address);
  }
  return addresses;
};

async function initDemo() {
  const user_demo = await User.findOne({ email: "user1@example.com" });

  //fill user's address. set 1 as default;
  const addresses = getDummyAddresses(5);
  const new_addresses = await Address.create(
    addresses.map((e) => {
      return { ...e, owner: user_demo };
    })
  );
  user_demo.default_address = new_addresses[0];
  await user_demo.save();

  //fill user's cart
  const cart_demo = await Cart.findOne({ owner: user_demo });
  let random_products;
  random_products = await Product.aggregate([{ $sample: { size: 10 } }]);
  for (const product of random_products) {
    await cart_demo.addToCart(product);
  }

  //fill user's wishlist
  const wishlist_demo = await UserWishlist.findOne({ owner: user_demo._id });
  random_products = await Product.aggregate([{ $sample: { size: 20 } }]);
  wishlist_demo.wishlist_products = random_products;
  await wishlist_demo.save();

  // fill user's transaction

  const available_addresses = await Address.find({ owner: user_demo._id });

  const sellers = await User.find({
    email: { $regex: "seller", $options: "i" },
  });

  const order_count = 50;
  const dates = random.consecutiveDate(
    (count = order_count),
    (days_range = 30)
  );

  for (let i = 0; i < order_count; i++) {
    let order = await Order.create({
      owner: user_demo._id,
      address:
        available_addresses[random.int(0, available_addresses.length - 1)],
      status: "paid",
      createdAt: dates[i],
      updatedAt: dates[i],
    });
    const order_item_count = random.poisson(1) + 1;
    const order_items = [];

    for (let j = 0; j < order_item_count; j++) {
      //get random seller
      const seller = sellers[random.int(0, sellers.length - 1)];
      //get random seller's product
      const products = await Product.aggregate([
        { $match: { owner: seller._id } },
        { $sample: { size: random.poisson(1) + 1 } },
      ]);
      const order_item_details = [];
      for (const product of products) {
        const order_item_detail = await OrderItemDetail.create({
          product: product,
          product_image: product.images[0],
          product_name: product.name,
          product_price: product.price,
          quantity: random.poisson(1) + 1,
        });
        order_item_details.push(order_item_detail);
      }
      const order_item = await OrderItem.create({
        order: order._id,
        buyer: user_demo._id,
        seller: seller._id,
        order_item_details,
        status: "completed",
        airwaybill: faker.helpers.replaceSymbols("TOCO????########"),
        createdAt: dates[i],
        updatedAt: dates[i],
      });
      order_items.push(order_item);
    }
    order.order_items = order_items;
    try {
      await order.save();
    } catch (e) {
      console.log(e);
    }
  }

  // fill user's reviews;

  let db_reviews = [];
  db_reviews = (await Review.find({ buyer: user_demo._id })).sort(
    () => 0.5 - Math.random()
  ); //shuffle reviews;
  db_reviews = db_reviews.slice(0, db_reviews.length * 0.8); // left 20% review on pending

  const curated_reviews_messages = Object.values(reviews)
    .flatMap((e) => e.map((e) => e.review))
    .filter((e) => e.length > 0);

  for (const review of db_reviews) {
    await Review.updateOne(
      { _id: review._id },
      {
        $set: {
          rating: random.rangedPoisson(1, 5, 5),
          review:
            curated_reviews_messages[
              random.int(0, curated_reviews_messages.length - 1)
            ],
          completed: true,
          total_update: 1,
        },
      },
      { timestamps: false }
    );
  }
}

mongoose.connection.once("open", async function () {
  const existing_categories = await Category.find();
  await initCategory(existing_categories);
  const existing_users = await User.find();
  await initUser(existing_users);
  const updated_categories = await Category.find();
  const updated_users = await User.find();
  const existing_products = await Product.find();
  await initProduct(updated_categories, updated_users, existing_products);
  const updated_products = await Product.find();
  const existing_reviews = await Review.find();
  await initReviews(updated_users, updated_products, existing_reviews);
  await initDemo();

  console.log("done");
  process.exit();
});
