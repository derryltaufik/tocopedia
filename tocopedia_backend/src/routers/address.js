const express = require("express");
const { Address } = require("../models/address");
const auth = require("../middleware/auth");

const router = new express.Router();

router.post("/addresses", auth, async (req, res) => {
  try {
    const address = new Address({
      ...req.body,
      owner: req.user._id,
    });
    await address.save();

    const updated_address = await address.populate("owner", "name _id");

    return res.status(201).send({ data: { address: updated_address } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/addresses/:id", auth, async (req, res) => {
  try {
    const address = await Address.findOne({ _id: req.params.id });
    if (!address) {
      return res.status(404).send({ error: "address not found" });
    }
    if (!address.owner.equals(req.user._id)) {
      return res
        .status(404)
        .send({ error: "you are not allowed to access this address" });
    }
    const updated_address = await address.populate("owner", "name _id");

    return res.status(200).send({ data: { address: updated_address } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/addresses", auth, async (req, res) => {
  try {
    const addresses = await Address.find({ owner: req.user._id }).populate(
      "owner",
      "name _id"
    );

    return res.status(200).send({ data: { results: addresses } });
  } catch (error) {
    res.status(400).send({ error: error.message });
  }
});

router.patch("/addresses/:id", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = [
    "label",
    "complete_address",
    "notes",
    "receiver_name",
    "receiver_phone",
  ];
  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );
  if (!isValidOperation) {
    return res.status(400).send({ error: "invalid or restricted updates" });
  }
  try {
    const address = await Address.findOne({ _id: req.params.id });
    if (!address) {
      return res.status(404).send({ error: "address not found" });
    }
    if (!address.owner.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "you are not allowed to update this address" });
    }
    updates.forEach((update) => (address[update] = req.body[update]));
    await address.save();

    const updated_address = await address.populate("owner", "name _id");

    return res.status(200).send({ data: { address: updated_address } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.delete("/addresses/:id", auth, async (req, res) => {
  try {
    const address = await Address.findById(req.params.id).populate(
      "owner",
      "name _id"
    );
    if (!address) {
      return res.status(404).send({ error: "address not found" });
    }
    if (!address.owner.equals(req.user._id)) {
      return res
        .status(403)
        .send({ error: "you are not allowed to delete this address" });
    }

    if (address._id.equals(req.user.default_address)) {
      return res
        .status(403)
        .send({ error: "you are not allowed to delete default address" });
    }
    await address.delete();
    return res.send({ data: { address } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
