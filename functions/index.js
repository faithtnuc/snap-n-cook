/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Finds matching recipes based on user-selected ingredients.
 * @param {Object} data - Request data containing user's ingredients.
 * @param {Object} context - The function execution context.
 * @returns {Promise<Array>} - An array of matching recipes with details and match percentages.
 */
exports.findMatchingRecipes = onCall((data, context) => {
  // 1. Get user-selected ingredients
  const myIngredients = data.data.ingredients;

  // 2. Access Firestore instance
  const db = admin.firestore();

  // 3. Query recipes collection
  return db.collection("recipes")
      // .limit(50) // Fetch only the first 50 recipes (For testing only)
      .get()
      .then((snapshot) => {
        // 4. Process each recipe document
        const matchingRecipes = [];
        snapshot.forEach((doc) => {
          const recipe = doc.data();
          const recipeIngredients = Array.from(new Set(recipe.ingredients.map((item) =>
            item.ingredient)));

          // 5. Calculate match percentage
          const matchPercentage = calculateMatchPercentage(myIngredients, recipeIngredients);

          // 6. Add recipe with details and match percentage to results
          const recipeMap = {
            "recipeId": doc.id,
            "recipeName": recipe.recipeName,
            "cookTime": recipe.cookTime,
            "prepTime": recipe.prepTime,
            "instructions": recipe.instructions,
            "recipeImage": recipe.recipeImage,
            "servingSize": recipe.servingSize,
            "matchPercentage": matchPercentage,
            "ingredients": recipe.ingredients,
          };

          matchingRecipes.push(recipeMap);
        });

        // 7. Sort recipes by match percentage (descending)
        matchingRecipes.sort((a, b) => b.matchPercentage - a.matchPercentage);

        // 8. Filter and limit results based on match percentage
        const filteredRecipes = matchingRecipes.filter(
            (recipe) => recipe.matchPercentage >= 70,
        );

        const recommendedRecipes = [];

        if (filteredRecipes.length>=10) {
          recommendedRecipes.push(...filteredRecipes);
        } else {
          recommendedRecipes.push(...matchingRecipes.filter(
              (recipe) => recipe.matchPercentage > 50,
          ).splice(0, 10));
        }

        return {recommendedRecipes: recommendedRecipes};
      });
});

/**
  * Calculates the match percentage between user ingredients and a recipe's ingredients.
  * @param {Array} myIngredients - An array of user's ingredients.
  * @param {Array} recipeIngredients - An array of a recipe's ingredients.
  * @return {number} - The calculated match percentage.
  */
function calculateMatchPercentage(myIngredients, recipeIngredients) {
  const matchingIngredients = myIngredients.filter((myIngredient) =>
    recipeIngredients.some((recipeIngredient) => recipeIngredient === myIngredient),
  );
  const percentage = (matchingIngredients.length / recipeIngredients.length) * 100;
  return percentage;
}
