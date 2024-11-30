import 'package:expanse_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpanseItem extends StatelessWidget {
  const ExpanseItem(this.expanse, {super.key});
  final Expanse expanse;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              expanse.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // ignore: unnecessary_string_interpolations, unnecessary_string_escapes
                Text('\₹${expanse.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryItems[expanse.category]),
                    const SizedBox(width: 8),
                    Text(expanse.formattedDate),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
