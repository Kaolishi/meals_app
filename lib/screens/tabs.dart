import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Method that adds meals to a list of favourite meals and updates the meals' status as 'favourite'
  // Will be passed to meal_details.dart
  void _toggleMealFavouriteStatus(Meal meal) {
    // Check if the meal is already in the list
    final isExisting = _favouriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a favourite');
      });
    } else {
      setState(() {
        _favouriteMeals.add(meal);
        _showInfoMessage('Meal is added as favourite');
      });
    }
  }

  // Method that updates _selectedPageIndex value based on the page the user is on
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Method that is executed when a drawer item is pressed
  void _setScreen(String identifier) {
    // Pops the side drawer before going to the next screen
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // pushReplacement replaces the current active screen instead of adding to the stack of screens
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavourite: _toggleMealFavouriteStatus,
    );
    var activePageTitle = 'Categories';

    // Changes the title and screen contents based on selectedPageIndex value
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favouriteMeals,
        onToggleFavourite: _toggleMealFavouriteStatus,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      //Scaffold allows you to set a bottom navigation bar using BottomNavigationBar widget
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        //currentIndex parameter tracks which tab will be highlighted based on selectedPageIndex
        currentIndex: _selectedPageIndex,
        // Items include the tabs of the bar which uses BottomNagivationBarItem widget
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
