import 'package:expanse_tracker/expanses.dart';
import 'package:expanse_tracker/widgets/chart/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:expanse_tracker/models/expense.dart';

// Define the categoryIcons map
final Map<Category, IconData> categoryIcons = {
  Category.Food: Icons.fastfood,
  Category.Leisure: Icons.movie,
  Category.Travel: Icons.flight,
  Category.Work: Icons.work,
};

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expanse> expenses; // Change from List<Expanses> to List<Expanse>

  List<ExpanseBucketClass> get buckets {
    return [
      ExpanseBucketClass.forCategory(expenses, Category.Food),
      ExpanseBucketClass.forCategory(expenses, Category.Leisure),
      ExpanseBucketClass.forCategory(expenses, Category.Travel),
      ExpanseBucketClass.forCategory(expenses, Category.Work),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpanses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpanses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.5),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpanses == 0
                        ? 0
                        : bucket.totalExpanses / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withRed(150),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
