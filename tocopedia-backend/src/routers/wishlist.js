const express = require("express");
const auth = require("../middleware/auth");
const { UserWishlist } = require("../models/user_wishlist");

const router = new express.Router();

const populateQuery = [
  {
    path: "owner",
    select: "_id name",
  },
  {
    path: "wishlist_products",
    select: "-description",
    populate: [
      {
        path: "owner",
        select: "_id name",
      },
      {
        path: "category",
        select: "_id name",
      },
    ],
  },
];

router.get("/wishlist", auth, async (req, res) => {
  try {
    const owner = req.user._id;

    let wishlist = await UserWishlist.findOne({ owner: owner }).populate(
      populateQuery
    );

    if (!wishlist) {
      wishlist = await UserWishlist.create({
        owner,
        wishlist_products: [],
      });
      await cart.save();
    }

    return res.status(200).send({ data: { wishlist: wishlist } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.post("/wishlist/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;

    let wishlist = await UserWishlist.findOne({ owner: owner });

    if (!wishlist) {
      wishlist = await UserWishlist.create({
        owner,
        wishlist_products: [product_id],
      });
    }
    if (wishlist) {
      await wishlist.wishlist_products.addToSet(product_id);
    }
    await wishlist.save();
    await wishlist.populate(populateQuery);

    return res.status(201).send({ data: { wishlist: wishlist } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.delete("/wishlist/:product_id", auth, async (req, res) => {
  try {
    const owner = req.user._id;
    const product_id = req.params.product_id;

    let wishlist = await UserWishlist.findOne({ owner: owner });

    if (!wishlist) {
      wishlist = await UserWishlist.create({
        owner,
        wishlist_products: [product_id],
      });
    }
    if (wishlist) {
      await wishlist.wishlist_products.pull(product_id);
    }
    await wishlist.save();
    await wishlist.populate(populateQuery);

    return res.status(201).send({ data: { wishlist: wishlist } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
