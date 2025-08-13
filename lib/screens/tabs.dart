import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/meals_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// A StatefulWidget that uses the Riverpod state management.
//
// `ConsumerStatefulWidget` is a variant of StatefulWidget that provides access to providers
// through the `ref` object, which is passed to its `createState` method.
// It allows the widget to listen to and interact with Riverpod Providers.
//
// This widget is the entry point of the application, managing the tab navigation
// between different screens such as categories and favorites.

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

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
  void _setScreen(String identifier) async {
    // Pops the side drawer before going to the next screen
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // async and await added to wait for the result when the user is done with the page
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        // ?? can set a default value if value is null
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // .watch reloads the build method when data inside it is changed
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavourite: _toggleMealFavouriteStatus,
      availableMeals: availableMeals,
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
