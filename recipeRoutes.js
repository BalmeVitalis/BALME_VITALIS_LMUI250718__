const express = require("express");

const router = express.Router();

const {
  getRecipes,
  createRecipe,
  updateRecipe,
  deleteRecipe,
} = require("../controllers/recipeController");

router.get("/", getRecipes);

router.post("/", createRecipe);

router.patch("/:id", updateRecipe);

router.delete("/:id", deleteRecipe);

module.exports = router;