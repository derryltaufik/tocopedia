const express = require("express");
const { Product } = require("../models/product");
const auth = require("../middleware/auth");
const { Category } = require("../models/category");
const { User } = require("../models/user");

const router = new express.Router();

const populateQuery = [
  {
    path: "owner",
    select: "_id name",
  },
  {
    path: "category",
    select: "_id name",
  },
];
const selectQuery = {
  description: 0,
  SKU: 0,
};

router.post("/products", auth, async (req, res) => {
  try {
    const product = new Product({
      ...req.body,
      owner: req.user._id,
    });

    const category = await Category.findById(req.body.category);
    product.category = category;

    await product.save();
    await product.populate(populateQuery);
    return res.status(201).send({ data: { product } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/products/popular", async (req, res) => {
  try {
    // pick 120 random items
    const results = await Product.aggregate([
      {
        $match: {
          status: "active",
          total_sold: { $gte: 1000 },
          average_rating: { $gte: 4.8 },
          price: { $gte: 10000 },
        },
      },
      { $sample: { size: 60 } },
      { $project: { description: 0 } },
    ]);

    await Category.populate(results, {
      path: "category",
      select: "_id name",
    });
    await User.populate(results, {
      path: "owner",
      select: "_id name",
    });
    if (!results) {
      return res.status(404).send({ error: "Product not found" });
    }

    return res.send({ data: { results } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/products/search", async (req, res) => {
  const query = Product.find({ status: "active" });

  if (req.query.category) {
    const category = await Category.findById(req.query.category);
    query.find({ category: category });
  }
  if (req.query.q) {
    query.find({ name: { $regex: req.query.q, $options: "i" } });
  }
  if (req.query["min-price"]) {
    query.find({ price: { $gte: req.query["min-price"] } });
  }
  if (req.query["max-price"]) {
    query.find({ price: { $lte: req.query["max-price"] } });
  }

  if (req.query["sort-by"]) {
    const option = req.query["sort-by"];
    let sortOrder = -1;
    if (req.query["sort-order"] === "asc") sortOrder = 1;

    if (option === "price") {
      query.sort({ price: sortOrder });
    } else if (option === "total-sold") {
      query.sort({ total_sold: sortOrder });
    } else if (option === "average-rating") {
      query.sort({ average_rating: sortOrder });
    } else if (option === "created-date") {
      query.sort({ createdAt: sortOrder });
    }
  }

  query.limit(200);
  try {
    const results = await Product.find(query)
      .populate(populateQuery)
      .select(selectQuery);
    if (!results) {
      return res.status(404).send({ error: "Product not found" });
    }
    return res.send({ data: { results } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/products/seller", auth, async (req, res) => {
  try {
    const results = await Product.find({ owner: req.user._id }, {})
      .sort({ createdAt: -1 })
      .populate(populateQuery)
      .select("-description");
    if (!results) {
      return res.status(404).send({ error: "Product not found" });
    }
    return res.send({ data: { results } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/products/:id", async (req, res) => {
  try {
    const product = await Product.findOne({ _id: req.params.id })
      .populate(populateQuery)
      .select("-SKU");
    if (!product) {
      return res.status(404).send({ error: "Product not found" });
    }

    return res.status(200).send({ data: { product } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/products/:id", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = [
    "name",
    "status",
    "description",
    "SKU",
    "stock",
    "images",
    "category",
    "price",
  ];
  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );
  if (!isValidOperation) {
    return res.status(400).send({ error: "invalid or restricted updates" });
  }
  try {
    const product = await Product.findOne({ _id: req.params.id });

    if (!product) {
      return res.status(404).send({ error: "product not found" });
    }

    if (!product.owner.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "you are not allowed to update this product" });
    }

    updates.forEach((update) => {
      product[update] = req.body[update];
    });

    if (req.body.category) {
      const category = await Category.findById(req.body.category);
      product.category = category;
    }

    await product.save();
    await product.populate(populateQuery);
    return res.send({ data: { product } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.delete("/products/:id", auth, async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate(
      populateQuery
    );
    if (!product) {
      return res.status(404).send({ error: "Product not found" });
    }
    if (!product.owner.equals(req.user._id)) {
      return res
        .status(404)
        .send({ error: "you are not allowed to delete this product" });
    }
    await product.delete();
    return res.send({ data: { product } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
