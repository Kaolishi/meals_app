import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick yo stuff'),
      ),
      // Gridview allows you to arrange elements in a grid
      // crossAxisCount determines the amount of columnes in the grid
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
