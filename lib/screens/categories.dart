import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Function to switch screeens
  void _selectCategory(BuildContext context) {
    // Use Nagivator widget to change between screens by pushing or poping screens
    // Push pushes a new screen to the top of the screen stack
    // Pop removes a screen from the top of the stack
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(title: 'Some title', meals: []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick yo stuff'),
      ),
      // Gridview allows you to arrange elements in a grid
      // crossAxisCount determines the amount of columnes in the grid
      body: GridView(
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
                _selectCategory(context);
              },
            ),
        ],
      ),
    );
  }
}
