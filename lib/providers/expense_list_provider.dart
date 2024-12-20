import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_expenses/models/expense.dart';

class ExpenseListProvider extends StateNotifier<List<Expense>> {
  bool isFetching = false;

  ExpenseListProvider() : super([]) {
    _initializeCategorySums();
  }
  final Map<Category, double> _categorySum = {
    Category.food: 0.0,
    Category.travel: 0.0,
    Category.leisure: 0.0,
    Category.bills: 0.0,
    Category.personal: 0.0,
  };

  Map<Category, double> get categorySum => _categorySum;

  void _initializeCategorySums() {
    for (Category category in Category.values) {
      _categorySum[category] = 0.0;
    }
  }

  Future<void> addItem(BuildContext context, String title, Category category,
      double price, DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final expense = Expense(
      title: title,
      categ: category,
      price: price,
      date: date,
    );

    try {
      final expenseDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .doc();
      await expenseDoc.set({
        'title': expense.title,
        'category': expense.categ.toString(),
        'price': expense.price,
        'date': expense.date.toIso8601String(),
      });
      _categorySum[expense.categ] =
          _categorySum[expense.categ]! + expense.price;
      state = [...state, expense];
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> fetchData({DateTime? month}) async {
    final datetime = month ?? DateTime.now();
    isFetching = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      _initializeCategorySums();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .get();

      final expenses = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            DateTime expenseDate;
            if (data['date'] is Timestamp) {
              expenseDate = (data['date'] as Timestamp).toDate();
            } else if (data['date'] is String) {
              expenseDate = DateTime.parse(data['date']);
            } else {
              throw Exception("Unexpected date format in Firestore");
            }
            if (expenseDate.month == datetime.month) {
              final newExpense = Expense(
                title: data['title'],
                categ: Category.values.firstWhere(
                  (category) => category.toString() == data['category'],
                ),
                price: data['price'],
                date: expenseDate,
              );
              _categorySum[newExpense.categ] =
                  _categorySum[newExpense.categ]! + newExpense.price;
              return newExpense;
            }
            return null;
          })
          .whereType<Expense>()
          .toList();

      isFetching = false;
      state = expenses;
    } catch (e) {
      isFetching = false;
      throw Exception('Failed to fetch data: $e');
    }
  }
}

final listprovider =
    StateNotifierProvider<ExpenseListProvider, List<Expense>>((ref) {
  return ExpenseListProvider();
});
