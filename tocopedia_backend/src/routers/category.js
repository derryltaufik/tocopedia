const express = require("express");
const { Category } = require("../models/category");

const router = new express.Router();

router.get("/categories/:id", async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    return res.status(201).send({ data: { category } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

router.get("/categories", async (req, res) => {
  try {
    const results = await Category.find();
    return res.status(201).send({ data: { results } });
  } catch (error) {
    return res.status(400).send({ error: error.message });
  }
});

module.exports = router;
