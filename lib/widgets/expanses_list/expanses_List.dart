// ignore_for_file: file_names

import 'package:expanse_tracker/models/expense.dart';
import 'package:expanse_tracker/widgets/expanses_list/expanses_item.dart';
import 'package:flutter/material.dart';

class ExpansesList extends StatelessWidget {
  const ExpansesList({
    super.key,
    required this.expanses,
    required this.onRemoveExpanse,
  });
  final List<Expanse> expanses;
  final void Function(Expanse expanse) onRemoveExpanse;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expanses.length,
      itemBuilder: (ctx, index) {
        final expanse = expanses[index];
        return Dismissible(
          key: ValueKey(expanse.id),
          onDismissed: (direction) {
            onRemoveExpanse(expanses[index]);
          },
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          child: ExpanseItem(expanses[index]),
        );
      },
    );
  }
}
