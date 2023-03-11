const express = require("express");
const auth = require("../middleware/auth");
const { User } = require("../models/user");

const router = new express.Router();

const populateQuery = {
  path: "default_address",
  select: "-owner",
};

router.post("/auth/signup", async (req, res) => {
  try {
    const { email } = req.body;
    const existing_user = await User.findOne({ email });
    if (existing_user) {
      res.status(400);
      res.json({ error: "email is already used" });
      return res;
    }

    const user = new User(req.body);
    await user.save();
    const token = await user.generateAuthToken();
    return res
      .status(201)
      .send({ data: { user: { ...user.toObject(), token } } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.post("/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findByCredentials(email, password);

    const token = await user.generateAuthToken();

    const updated_user = await user.populate(populateQuery);

    return res.send({ data: { user: { ...updated_user.toObject(), token } } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
