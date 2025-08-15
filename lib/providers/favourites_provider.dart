import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

// StateNotifier is a class that manages state and notifies listeners when state changes.
class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]);

  // When working with state in StateNotifier, we should treat the state as immutable
  // and create a new state object instead of modifying the existing one.
  // This helps with predictable state management, efficient change detection,
  // and prevents bugs related to unexpected mutations.
  bool toggleMealFavouriteStatus(Meal meal) {
    final mealIsFavourite = state.contains(meal);

    // If the meal is already a favorite, remove it by filtering out the meal with the matching id
    // Otherwise, add the meal to favorites by creating a new list that includes all current favorites plus the new meal
    if (mealIsFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

// This provider gives access to both the list of favorite meals and the methods to modify it
final favouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
      return FavouriteMealsNotifier();
    });
