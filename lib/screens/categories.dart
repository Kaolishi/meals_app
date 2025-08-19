import 'package:flutter/material.dart';

import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller to manage the entrance animation of the categories grid
  // SingleTickerProviderStateMixin provides the vsync for smooth animations
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with specific parameters
    _animationController = AnimationController(
      vsync: this, // Use this widget as the ticker provider
      duration: const Duration(milliseconds: 300), // Animation duration
      lowerBound: 0, // Animation starts from 0
      upperBound: 1, // Animation ends at 1
    );

    // Start the animation immediately when the screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    // Clean up the animation controller to prevent memory leaks
    // Always dispose of animation controllers when the widget is destroyed
    _animationController.dispose();
    super.dispose();
  }

  // Function to switch screeens
  void _selectCategory(BuildContext context, Category category) {
    // where keyword iterates through a list and returns a new iterable based on set conditions
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    // Use Nagivator widget to change between screens by pushing or poping screens
    // Push pushes a new screen to the top of the screen stack
    // Pop removes a screen from the top of the stack
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gridview allows you to arrange elements in a grid
    // crossAxisCount determines the amount of columnes in the grid
    // Wrap the grid in AnimatedBuilder to create smooth entrance animation
    return AnimatedBuilder(
      animation: _animationController,
      // The child parameter contains the widget that will be animated
      // This optimization prevents rebuilding the GridView on every animation frame
      child: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      // Builder function that defines how the animation should be applied
      builder: (context, child) => SlideTransition(
        position:
            // Create a Tween animation that moves from bottom to center
            Tween(
              begin: const Offset(
                0,
                0.3,
              ), // Start 30% down from original position
              end: const Offset(0, 0), // End at original position
            ).animate(
              // Apply easing curve for smooth, natural movement
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut, // Smooth acceleration and deceleration
              ),
            ),
        child: child, // The GridView widget to be animated
      ),
    );
  }
}
