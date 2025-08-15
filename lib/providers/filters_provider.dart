import 'package:flutter_riverpod/flutter_riverpod.dart';

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
