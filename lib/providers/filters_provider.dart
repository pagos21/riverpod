import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_providers.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });
  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; #ASSOLUTUMANTE NON PERMESSO
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<Filter, bool> choosenFilter) {
    state = choosenFilter;
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
  (ref) => FilterNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  //function re executed when the watcher change
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filterProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
