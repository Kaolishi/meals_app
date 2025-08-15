import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/meals_provider.dart';

// Enum defining the available dietary filter types
// These filters help users narrow down meal options based on dietary preferences
enum Filter {
  glutenFree, // Filter for gluten-free meals
  lactoseFree, // Filter for lactose-free meals
  vegetarian, // Filter for vegetarian meals
  vegan, // Filter for vegan meals
}

// StateNotifier class that manages the state of dietary filters
// Extends StateNotifier with Map<Filter, bool> as the state type
// The state is a map where each Filter enum is associated with a boolean value
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  // Constructor initializes the state with all filters set to false (inactive)
  // This means by default, no dietary filters are applied
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });

  // Method to set multiple filters at once
  // Takes a complete map of filter states and replaces the current state
  // Useful when applying filter changes from a settings screen
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  // Method to set a single filter's active state
  // Takes a specific Filter and boolean value to update just that filter
  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // Not Allowed - this would mutate the state directly
    // StateNotifier requires immutable state updates, so we create a new map
    // Using spread operator (...) to copy existing state and override specific filter
    state = {
      ...state,
      filter: isActive,
    };
  }
}

// Provider that exposes the FiltersNotifier to the widget tree
// StateNotifierProvider manages the FiltersNotifier instance and its state
// Other widgets can read from this provider to get current filter states
// or access the notifier to modify filter settings
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
      (ref) => FiltersNotifier(), // Creates a new FiltersNotifier instance
    );

// Provider that computes filtered meals based on active dietary filters
// This is a computed Provider that depends on both mealsProvider and filtersProvider
// It automatically recalculates when either the meals data or filter settings change
final filteredMealsProvider = Provider((ref) {
  // Watch the meals provider to get the complete list of available meals
  final meals = ref.watch(mealsProvider);
  // Watch the filters provider to get current filter states
  final activeFilters = ref.watch(filtersProvider);

  // Filter meals based on active dietary preferences
  // Uses where() method to check each meal against all active filters
  return meals.where((meal) {
    // If gluten-free filter is active and meal contains gluten, exclude it
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    // If lactose-free filter is active and meal contains lactose, exclude it
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    // If vegetarian filter is active and meal is not vegetarian, exclude it
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    // If vegan filter is active and meal is not vegan, exclude it
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    // If meal passes all active filter checks, include it in the result
    return true;
  }).toList(); // Convert filtered iterable to List
});
