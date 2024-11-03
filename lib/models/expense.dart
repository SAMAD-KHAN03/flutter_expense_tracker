import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  leisure,
  bills,
  personal,
}

final categoryIcons = {
  Category.food: Icons.dinner_dining_outlined,
  Category.travel: Icons.flight,
  Category.leisure: Icons.free_breakfast,
  Category.bills: Icons.attach_money_sharp,
  Category.personal: Icons.person
};

class Expense {


  final String id;
  final String title;
  final Category categ;
  final double price;
  DateTime date;


  Expense({
    required this.title,
    required this.categ,
    required this.price,
    required this.date,
  }) : id = const Uuid().v4();

  String get formattedDate {
    return formatter.format(date);
  }
}
