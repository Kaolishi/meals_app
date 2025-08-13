import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';

/// Provides a list of meals to the application.
///
/// This provider is responsible for maintaining and exposing meal data
/// to widgets that need access to it. Providers are used for
/// state management, allowing data to be accessed from various parts of
/// the widget tree without passing it explicitly through constructors.
///
/// The Provider pattern separates data management from UI components,
/// making the code more maintainable and testable.
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
