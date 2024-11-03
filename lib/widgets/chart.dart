import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/providers/expense_list_provider.dart';
import 'package:my_expenses/widgets/chartbar.dart';

class Chart extends ConsumerWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(listprovider);
    final categorySumMap = ref.read(listprovider.notifier).categorySum;

    // Calculate total amount from the current expenses
    double totalAmount =
        expenses.fold(0.0, (sum, expense) => sum + expense.price);
    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.primary.withOpacity(0.0)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: categorySumMap.values.map((categorySum) {
                  double ratio =
                      totalAmount == 0 ? 0 : categorySum / totalAmount;

                  return ChartBar(
                    fill: ratio,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: Category.values.map((category) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      categoryIcons[category],
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ));
  }
}
