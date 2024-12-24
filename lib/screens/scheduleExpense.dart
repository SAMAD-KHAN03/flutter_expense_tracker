import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/animations/slide_transition.dart';
import 'package:my_expenses/providers/expense_list_provider.dart';
import 'package:my_expenses/screens/add_expense_screen.dart';
import 'package:my_expenses/widgets/card_widget.dart';

class ScheduleExpense extends ConsumerStatefulWidget {
  const ScheduleExpense({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleExpenses();
}

class _ScheduleExpenses extends ConsumerState<ScheduleExpense> {
  @override
  Widget build(BuildContext context) {
    final list = ref
        .watch(listprovider)
        .where((expense) => expense.dueDate.isAfter(DateTime.now()) == true)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule Expenses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            SlideTransitionUtil.slideTransition(const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CardWidget(
          list: list,
        ),
      ),
    );
  }
}
