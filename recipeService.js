const Recipe = require("../models/recipeModel");

const getRecipes = async (category) => {
  if (category) {
    return await Recipe.find({ category });
  }

  return await Recipe.find();
};

const createRecipe = async (data) => {
  if (data.cookingTime <= 0) {
    throw new Error("Cooking time must be positive");
  }

  return await Recipe.create(data);
};

const updateRecipe = async (id, data) => {
  return await Recipe.findByIdAndUpdate(id, data, {
    new: true,
    runValidators: true,
  });
};

const deleteRecipe = async (id) => {
  return await Recipe.findByIdAndDelete(id);
};

module.exports = {
  getRecipes,
  createRecipe,
  updateRecipe,
  deleteRecipe,
};