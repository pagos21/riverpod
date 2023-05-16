import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/providers/favourites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    // required this.onToggleFavorite,
  });

  final Meal meal;
  // final void Function(Meal meal) onToggleFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favoriteMealsProvider);
    final bool isFav = favouriteMeals.contains(meal);
    return Scaffold(
        appBar: AppBar(title: Text(meal.title), actions: [
          IconButton(
            onPressed: () {
              //All'interno delle funzione è necessario mettere read invece che watch
              final wasAdded =
                  ref.read(favoriteMealsProvider.notifier).toggleMealsFav(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(wasAdded ? "OOOk" : "RIMOSSO")));
            },
            //Animazione Implcit
            icon: AnimatedSwitcher(
              transitionBuilder: (child, animation) => RotationTransition(
                turns: animation,
                // turns: Tween<double>(begin: 0.5, end: 1).animate(animation),
                child: child,
              ),
              duration: const Duration(milliseconds: 500),
              child: Icon(
                isFav ? Icons.star : Icons.star_border,
                key: ValueKey(isFav),
              ),
            ),
          )
        ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: meal.id,
                child: Image.network(
                  meal.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final ingredient in meal.ingredients)
                Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              const SizedBox(height: 24),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final step in meal.steps)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
            ],
          ),
        ));
  }
}
