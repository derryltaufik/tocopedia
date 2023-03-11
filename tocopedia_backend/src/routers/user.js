const express = require("express");
const auth = require("../middleware/auth");
const { Address } = require("../models/address");
const { User } = require("../models/user");

const router = new express.Router();

const populateQuery = [
  {
    path: "default_address",
    select: "-owner",
  },
];

router.get("/users", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate(populateQuery);
    return res.status(200).send({ data: { user } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.patch("/users", auth, async (req, res) => {
  const updates = Object.keys(req.body);
  const allowedUpdates = ["name", "default_address"];
  const isValidOperation = updates.every((update) =>
    allowedUpdates.includes(update)
  );
  if (!isValidOperation) {
    return res.status(400).send({ error: "invalid or restricted updates" });
  }
  try {
    const user = req.user;
    updates.forEach((update) => (user[update] = req.body[update]));

    if (req.body.default_address) {
      const default_address = await Address.findById(req.body.default_address);
      if (!default_address)
        return res.status(404).send({ error: "you have not add this address" });
      user.default_address = default_address;
    }

    await user.save();

    const updated_user = await User.findById(req.user._id).populate(
      populateQuery
    );

    return res.send({ data: { user: { ...updated_user.toObject() } } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

// router.put("/users/change-password", auth, async (req, res) => {
//   //must contain both old and new password
//   const { old_password, new_password } = req.body;
//   if (!old_password || !new_password) {
//     return res.status(400).send({ error: "old or new password not provided" });
//   }
//   try {
//     const user = await User.findByCredentials(req.user.email, old_password);

//     user.password = new_password;

//     await user.save();

//     const token = await user.generateAuthToken();

//     const updated_user = await user.populate(populateQuery);

//     return res.send({ data: { user: { ...updated_user.toObject(), token } } });
//   } catch (error) {
//     return res.status(400).send({ error: error.message });
//   }
// });

module.exports = router;
