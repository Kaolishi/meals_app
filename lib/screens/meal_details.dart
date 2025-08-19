import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';

// Screen that displays detailed information about a specific meal
// Uses ConsumerWidget to access Riverpod providers for managing favourite meals
class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal});

  // The meal object containing all the details to be displayed
  final Meal meal;

  // WidgetRef ref is added to listen from providers
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favourites provider to get current list of favourite meals
    // This will rebuild the widget when the favourites list changes
    final favouriteMeals = ref.watch(
      favouriteMealsProvider,
    ); // Watching the provider to rebuild when state changes

    // Check if the current meal is in the favourites list
    final isFavourite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        // actions adds buttons to the AppBar
        // Favourite toggle button in the app bar
        actions: [
          IconButton(
            // Handle favourite toggle when button is pressed
            onPressed: () {
              // Using ref.read to access the favouriteMealsProvider notifier
              // which lets us call methods that can modify the provider state
              final wasAdded = ref
                  .read(favouriteMealsProvider.notifier)
                  .toggleMealFavouriteStatus(meal);
              // Clear any existing snack bars to avoid stacking
              ScaffoldMessenger.of(context).clearSnackBars();
              // Show feedback to user about the favourite action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? 'Meal added as a favorite' : 'Meal removed',
                  ),
                ),
              );
            },
            // Dynamic icon based on favourite status (filled star vs outline)
            // AnimatedSwitcher provides smooth transition when icon changes
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // Custom transition builder for rotation animation
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  // Rotate from 80% to 100% (0.8 to 1) for subtle spin effect
                  turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                // ValueKey ensures AnimatedSwitcher recognizes when to animate
                // Different keys trigger the transition animation
                key: ValueKey(isFavourite),
              ),
            ),
          ),
        ],
      ),
      // Scrollable content area for meal details
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image of the meal
            // Hero widget creates smooth transition animation when navigating from meal list
            Hero(
              tag: meal.id, // Unique tag to match with hero in previous screen
              child: Image.network(
                meal.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover, // Ensures image covers the full width
              ),
            ),
            const SizedBox(height: 14),

            // Ingredients section header
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Display each ingredient in the list
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 24),

            // Cooking steps section header
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Display each cooking step with proper formatting
            for (final steps in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Text(
                  steps,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
