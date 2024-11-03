import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:my_expenses/animations/loading_animation.dart';
import 'package:my_expenses/animations/slide_transition.dart';
import 'package:my_expenses/providers/auth_provider.dart';
import 'package:my_expenses/providers/expense_list_provider.dart';
import 'package:my_expenses/screens/add_expense_screen.dart';
import 'package:my_expenses/widgets/card_widget.dart';
import 'package:my_expenses/widgets/chart.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<ExpenseScreen> {
  var _selectedMonth = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      ref.read(listprovider.notifier).fetchData();
    }
  }

  void _openMonthPicker() async {
    final pickedMonth = await showMonthPicker(context: context);
    if (pickedMonth != null) {
      setState(() {
        _selectedMonth = pickedMonth;
        ref.read(listprovider.notifier).fetchData(month: _selectedMonth);
      });
    }
  }

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  Widget build(BuildContext context) {
    var auth = ref.watch(authenticationProvider);
    final list = ref.watch(listprovider);
    bool isfetching = ref.watch(listprovider.notifier).isFetching;
    double totalAmount =
        ref.watch(listprovider.notifier).categorySum.values.fold(
              0.0,
              (sum, v) => sum + v,
            );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Row(
            children: [
              Text(
                months[_selectedMonth.month - 1],
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      _openMonthPicker();
                    },
                    icon: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.black,
                    )),
              ),
            ],
          )
        ],
        title: const Text(
          'Expenses',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        focusElevation: 2.0,
        onPressed: () {
          Navigator.of(context).push(
              SlideTransitionUtil.slideTransition(const AddExpenseScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: isfetching
          ? const Center(
              child: LoadingAnimation(),
            )
          : list.isEmpty
              ? const Center(
                  child: Text('No Expense Added...'),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                        child: Text(
                          "Total Amount Spent: ${totalAmount.toStringAsFixed(2)} Rs",
                        ),
                      ),
                      const Chart(),
                      const CardWidget(),
                    ],
                  ),
                ),
    );
  }
}
