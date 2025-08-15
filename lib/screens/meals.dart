import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_details.dart';
import 'package:meals_app/widgets/meal_item.dart';

// Screen that displays a list of meals in a scrollable format
// Can be used to show meals from a specific category or filtered meals
// Uses StatelessWidget as it doesn't need to manage internal state
class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  // Optional title for the screen - used when showing meals with an AppBar
  // ? is added to make the title optional in order to make the Scaffold below optional
  final String? title;
  // List of meals to be displayed in this screen
  final List<Meal> meals;

  // Navigation method to handle meal selection and route to detail screen
  // Takes the selected meal and navigates to MealDetailsScreen
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Default content: scrollable list of meals using ListView.builder for efficiency
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        // Pass callback function to handle meal selection
        onSelectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );

    // To handle cases where the meals list is empty
    // Show user-friendly empty state with helpful message
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main empty state message
            Text(
              'Oh no..... it\'s empty!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            // Helpful suggestion text
            Text(
              'Try selecting another category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    // If no title is provided, return content without Scaffold
    // This allows the screen to be embedded in other widgets (like tabs)
    if (title == null) {
      return content;
    }

    // If title is provided, wrap content in a full Scaffold with AppBar
    return Scaffold(
      appBar: AppBar(
        // ! added to title as we KNOW that a null value is caught above
        title: Text(title!),
      ),
      body: content,
    );
  }
}
