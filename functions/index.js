/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

/*
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
*/

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.getRecommendedRecipes = functions.https.onCall(async (data, context) => {
  const detectedIngredients = data.detectedIngredients;

  // Fetch all recipes from Firestore
  const snapshot = await admin.firestore().collection("recipes").get();
  const recipes = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));

  // Calculate match percentages
  const matches = recipes.map((recipe) => {
    const matchCount = recipe.ingredients.filter((ingredient) =>
      detectedIngredients.includes(ingredient),
    ).length;
    const matchPercentage = (matchCount / recipe.ingredients.length) * 100;
    return {...recipe, matchPercentage};
  });

  // Filter recipes with at least 70% match
  const filteredMatches = matches.filter((recipe) => recipe.matchPercentage >= 70);

  // Sort recipes by match percentage
  filteredMatches.sort((a, b) => b.matchPercentage - a.matchPercentage);

  // If there are more than 10 recipes with above 90% match, return all of them
  const topMatches = filteredMatches.filter((recipe) => recipe.matchPercentage >= 90);

  if (topMatches.length > 10) {
    return topMatches;
  } else {
    return filteredMatches.slice(0, 10);
  }
});


