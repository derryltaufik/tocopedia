const jwt = require("jsonwebtoken");
const { User } = require("../models/user");

const auth = async (req, res, next) => {
  try {
    const token = req.header("Authorization").replace("Bearer ", "");

    if (!token) {
      return res
        .status(401)
        .json({ error: "no auth token provided in the header" });
    }

    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (!payload) {
      return res.status(401).json({ error: "token not authorized" });
    }

    const user = await User.findById(payload._id);

    if (!user) {
      return res.status(404).json({ error: "user not found" });
    }

    req.token = token;
    req.user = user;
    next();
  } catch (error) {
    res.status(401).send({ error: "Authentication error" });
  }
};

module.exports = auth;
