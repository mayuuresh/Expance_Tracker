// ignore_for_file: constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category { Food, Travel, Leisure, Work }

const categoryItems = {
  Category.Food: Icons.lunch_dining,
  Category.Travel: Icons.flight_takeoff,
  Category.Leisure: Icons.movie,
  Category.Work: Icons.work
};

class Expanse {
  Expanse({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.key, // Firebase key (optional)
  }) : id = uuid.v4(); // Unique ID generated locally

  final String title;
  final double amount;
  final String id; // Local unique ID
  final DateTime date;
  final Category category;
  final String? key; // Firebase key (optional)

  String get formattedDate {
    return formatter.format(date);
  }

  // Factory method to create an Expanse from Firebase snapshot
  factory Expanse.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Expanse(
      title: data['title'],
      amount: double.parse(data['amount']),
      date: DateTime.parse(data['date']),
      category: Category.values.firstWhere((e) => e.name == data['category']),
      key: snapshot.key, 
    );
  }

  // Method to convert the Expanse object into a Map to save to Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount.toString(),
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }
}
