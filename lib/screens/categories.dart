import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Function to switch screeens
  void _selectCategory(BuildContext context, Category category) {
    // where keyword iterates through a list and returns a new iterable based on set conditions
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    // Use Nagivator widget to change between screens by pushing or poping screens
    // Push pushes a new screen to the top of the screen stack
    // Pop removes a screen from the top of the stack
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gridview allows you to arrange elements in a grid
    // crossAxisCount determines the amount of columnes in the grid
    return GridView(
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
    );
  }
}
