import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  //Method that updates _selectedPageIndex value based on the page the user is on
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';

    // Changes the title and screen contents based on selectedPageIndex value
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(meals: []);
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
