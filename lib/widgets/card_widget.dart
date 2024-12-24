import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/expense.dart';


class CardWidget extends ConsumerWidget {
  List<Expense?> list;
  CardWidget({super.key, required this.list});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var allExpenseList = ref.watch(listprovider).map((expense) {});
    return list.isEmpty
        ? const Center(
            child: Text('No Expenses Added'),
          )
        : Column(
            children: [
              for (var expense in list)
                Card(
                  color: Theme.of(context).cardTheme.color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          categoryIcons[expense!.categ],
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.title,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                expense.categ.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    expense.price.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Text(
                                expense.formattedDate,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                "${expense.date.hour.toString().padLeft(2, '0')}:${expense.date.minute.toString().padLeft(2, '0')}:${expense.date.second.toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          );
  }
}
