import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/providers/expense_list_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  TextEditingController price = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  var _pickedDate = DateTime.now();
  var _selectedCategory = Category.bills;

  void _openDatePicker(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(currentDateTime.year - 100),
      lastDate: DateTime(currentDateTime.year + 100),
    );
    if (selectedDate != null && selectedDate != currentDateTime) {
      setState(() {
        _pickedDate = selectedDate;
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hours.toString().padLeft(2, '0')}:$minutes $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Go Back',
          style: TextStyle(color: Color.fromARGB(255, 217, 217, 217)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: title,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text('title')),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatter.format(_pickedDate),
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _openDatePicker(context);
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: price,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(label: Text('\$ price')),
                  ),
                ),
                const SizedBox(width: 20),
                DropdownMenu<Category>(
                  initialSelection: _selectedCategory,
                  onSelected: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  leadingIcon: Icon(categoryIcons[_selectedCategory]),
                  dropdownMenuEntries: Category.values
                      .map<DropdownMenuEntry<Category>>((individualCategory) {
                    return DropdownMenuEntry(
                      value: individualCategory,
                      label: individualCategory.name.toUpperCase(),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (title.text.isEmpty ||
                        price.text.isEmpty ||
                        double.tryParse(price.text) == null) {
                      return;
                    }
                    ref.watch(listprovider.notifier).addItem(
                        context,
                        title.text,
                        _selectedCategory,
                        double.tryParse(price.text)!,
                        _pickedDate,
                        formatTime(TimeOfDay.now()));
                    price.clear();
                    title.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      price.clear();
                      title.clear();
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
