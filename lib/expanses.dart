import 'package:expanse_tracker/widgets/chart/chart.dart';
import 'package:expanse_tracker/widgets/expanses_list/new_expanse.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:expanse_tracker/models/expense.dart';
import 'package:expanse_tracker/widgets/expanses_list/expanses_list.dart';

class Expanses extends StatefulWidget {
  const Expanses({super.key});

  @override
  State<Expanses> createState() => _ExpansesState();
}

class _ExpansesState extends State<Expanses> {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child("Expanse");
  List<Expanse> _expanses = [];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  void _fetchExpenses() async {
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Expanse> loadedExpenses = [];
        data.forEach((key, value) {
          loadedExpenses.add(
            Expanse(
              title: value['title'],
              amount: double.parse(value['amount']),
              date: DateTime.parse(value['date']),
              category: Category.values
                  .firstWhere((e) => e.name == value['category']),
                  key: key
            ),
          );
        });

        setState(() {
          _expanses = loadedExpenses;
        });
      }
    });
  }

  void _removeExpanse(Expanse expanse) async {
  final expenseKey = expanse.key; 

  setState(() {
    _expanses.remove(expanse);
  });
  if (expenseKey != null) {
    try {
      await dbRef.child(expenseKey).remove(); 
    } catch (e) {
      // Handle error if any
      print("Error deleting expense: $e");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expanse Tracker"),
      ),
      body: Column(
        children: [
          // Show the chart if there are expenses
          if (_expanses.isNotEmpty)
            // Wrap Chart in Expanded to allow it to take up available space
            Expanded(child: Chart(expenses: _expanses)),

          // Display the list of expenses or a message if there are no expenses
          _expanses.isEmpty
              ? const Center(
                  child: Text("No expenses added yet!"),
                )
              : Expanded(
                  child: ExpansesList(
                    expanses: _expanses,
                    onRemoveExpanse: _removeExpanse,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openNewExpanseOverlay(context),
      ),
    );
  }

  void _openNewExpanseOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewExpanse(
          onAddExpanse: (newExpanse) {
            setState(() {
              _expanses.add(newExpanse);
            });
          },
        );
      },
    );
  }
}

class ExpanseBucketClass {
  final Category category;
  final double totalExpanses;

  ExpanseBucketClass(this.category, this.totalExpanses);

  // Factory constructor to create an ExpanseBucketClass for a particular category
  factory ExpanseBucketClass.forCategory(
      List<Expanse> expenses, Category category) {
    double total = 0;

    for (final expanse in expenses) {
      if (expanse.category == category) {
        total += expanse.amount;
      }
    }

    return ExpanseBucketClass(category, total);
  }
}
