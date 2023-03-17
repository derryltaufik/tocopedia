const express = require("express");
const auth = require("../middleware/auth");
const { Review } = require("../models/review");

const router = new express.Router();

const populateQuery = [
  {
    path: "order_item_detail",
    select: "_id",
  },
  {
    path: "seller",
    select: "_id name",
  },
  {
    path: "buyer",
    select: "name -_id",
  },
  {
    path: "product",
    select: "_id",
  },
];

const selectQuery = {
  // address: 1,
};

//get order_items

router.post("/reviews/:order_item_detail_id", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = ["rating", "images", "review", "anonymous"];
  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );
  if (!isValidOperation) {
    return res.status(400).send({ error: "invalid or restricted updates" });
  }

  try {
    const review = await Review.findOne({
      order_item_detail: req.params.order_item_detail_id,
      completed: false,
    });
    if (!review)
      return res.status(403).send({ error: "can not post new review" });

    if (!review.buyer.equals(req.user._id))
      return res
        .status(403)
        .send({ error: "you are not allowed to review this product" });

    updates.forEach((update) => {
      review[update] = req.body[update];
    });
    await review.save();
    await review.populate(populateQuery);

    return res.status(201).send({ data: { review } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/reviews/:review_id", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = ["rating", "images", "review", "anonymous"];
  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );
  if (!isValidOperation) {
    return res.status(400).send({ error: "invalid or restricted updates" });
  }

  try {
    const review = await Review.findById(req.params.review_id);
    if (!review) return res.status(403).send({ error: "review not found" });

    if (!review.buyer.equals(req.user._id))
      return res
        .status(403)
        .send({ error: "you are not allowed to review this product" });

    updates.forEach((update) => {
      review[update] = req.body[update];
    });

    await review.save();
    await review.populate(populateQuery);

    return res.status(200).send({ data: { review } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/reviews/buyer", auth, async (req, res) => {
  try {
    let reviews = await Review.find({ buyer: req.user._id })
      .sort({ updatedAt: -1 })
      .populate(populateQuery);

    if (!reviews) return res.status(404).send({ error: "review not found" });

    reviews = reviews.map((review) => {
      review = truncateReview(review);
      return review;
    });

    return res.send({ data: { results: reviews } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/reviews/seller/:seller_id", async (req, res) => {
  try {
    let reviews = await Review.find({
      seller: req.params.seller_id,
      completed: true,
    })
      .sort({ updatedAt: -1 })
      .populate(populateQuery);

    if (!reviews) return res.status(404).send({ error: "review not found" });

    reviews = reviews.map((review) => {
      review = censorBuyerName(review);
      review = truncateReview(review);
      return review;
    });

    return res.send({ data: { results: reviews } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/reviews/products/:product_id", async (req, res) => {
  try {
    const product_id = req.params.product_id;
    let reviews = await Review.find({
      product: product_id,
      completed: true,
    })
      .sort({ updatedAt: -1 })
      .populate(populateQuery);

    if (!reviews)
      return res
        .status(404)
        .send({ error: "this product does not have any review" });

    reviews = reviews.map((review) => (review = censorBuyerName(review)));

    return res.send({ data: { results: reviews } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/reviews/:review_id", auth, async (req, res) => {
  try {
    let review = await Review.findById(req.params.review_id)
      .sort({ updatedAt: -1 })
      .populate(populateQuery);

    if (!review) return res.status(404).send({ error: "review not found" });

    review = censorBuyerName(review);

    return res.send({ data: { review } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

const censorBuyerName = (review) => {
  const newReview = { ...review.toObject() };
  const name = newReview.buyer.name;

  if (review.anonymous === true) {
    newReview.buyer.name = `${name[0]}***${name.slice(-1)}`;
  }

  return newReview;
};

const truncateReview = (review) => {
  if (review.review) {
    review.review = review.review.substring(0, 200);
  }
  return review;
};

module.exports = router;
