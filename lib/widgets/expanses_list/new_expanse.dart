// ignore_for_file: avoid_print, use_function_type_syntax_for_parameters

import 'dart:io';

import 'package:expanse_tracker/models/expense.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpanse extends StatefulWidget {
  const NewExpanse({super.key, required this.onAddExpanse});
  final void Function(Expanse expanse) onAddExpanse;

  @override
  State<StatefulWidget> createState() {
    return _NewExpansesState();
  }
}

class _NewExpansesState extends State<NewExpanse> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late DatabaseReference dbref =
      FirebaseDatabase.instance.ref().child("Expanse");

  DateTime? _selectedDate;
  // ignore: unused_field
  Category _selectedCategory = Category.Leisure;

  void submitExpanseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Invalid Input"),
                  content: const Text(
                      "Please enter a valid title, amount, date and category"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Okey"),
                    )
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Invalid Input"),
                  content: const Text(
                      "Please enter a valid title, amount, date and category"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Okey"))
                  ],
                ));
      }
      return;
    }

    // Convert DateTime to Firestore Timestamp
    // final timestamp = Timestamp.fromDate(_selectedDate!);

    widget.onAddExpanse(
      Expanse(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Map<String, String> expanse = {
      'title': _titleController.text,
      'amount': _amountController.text,
      'date': _selectedDate.toString(),
      'category': _selectedCategory.name,
    };
    dbref.push().set(expanse);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void percentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardspace = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardspace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text, //by default is text
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Title")),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType:
                          TextInputType.number, // by default is number
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                        prefixText: '₹', // by default is number
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? "No date selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                            onPressed: percentDatePicker,
                            icon: const Icon(Icons.calendar_month)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase())))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: submitExpanseData,
                      child: const Text("Save expanse"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
