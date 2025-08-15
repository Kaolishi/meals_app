import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';

// Initial filter configuration with all filters set to false (inactive)
// This serves as the default state when no custom filters have been applied
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// Main navigation screen that manages tab-based navigation
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
  // Index tracking which tab is currently selected (0 = Categories, 1 = Favourites)
  int _selectedPageIndex = 0;

  // Method that updates _selectedPageIndex value based on the page the user is on
  // Called when user taps on bottom navigation bar items
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Method that is executed when a drawer item is pressed
  // Handles navigation to different screens from the side drawer
  void _setScreen(String identifier) async {
    // Pops the side drawer before going to the next screen
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // async and await added to wait for the result when the user is done with the page
      // Navigate to filters screen and potentially receive filter data back
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // .watch reloads the build method when data inside it is changed
    // Get filtered meals based on current filter settings from the provider
    final availableMeals = ref.watch(filteredMealsProvider);

    // Default screen and title for Categories tab (index 0)
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    // Changes the title and screen contents based on selectedPageIndex value
    // Switch to Favourites tab when index is 1
    if (_selectedPageIndex == 1) {
      // Get favourite meals from the favourites provider
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouriteMeals,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      // Side drawer for additional navigation options (filters, etc.)
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      // Main content area showing either Categories or Favourites screen
      body: activePage,
      // Scaffold allows you to set a bottom navigation bar using BottomNavigationBar widget
      // Bottom navigation with two tabs: Categories and Favourites
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        // currentIndex parameter tracks which tab will be highlighted based on selectedPageIndex
        currentIndex: _selectedPageIndex,
        // Items include the tabs of the bar which uses BottomNavigationBarItem widget
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
