import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/providers/auth_provider.dart';
import 'package:my_expenses/providers/expense_list_provider.dart';
import 'package:my_expenses/screens/add_expense_screen.dart';
import 'package:my_expenses/widgets/card_widget.dart';
import 'package:my_expenses/widgets/chart.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      ref.read(listprovider.notifier).fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = ref.watch(authenticationProvider);
    ref.watch(listprovider);
    bool isfetching = ref.watch(listprovider.notifier).isFetching;
    double totalAmount =
        ref.watch(listprovider.notifier).categorySum.values.fold(
              0.0,
              (sum, v) => sum + v,
            );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: InkWell(
              onTap: () async {
                await auth.signOut();
              },
              child: auth.isSignout
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Chip(
                      label: const Text('Sign out'),
                      elevation: 20,
                      avatar: const Icon(Icons.logout_outlined),
                      shadowColor: Colors.black,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      padding: const EdgeInsets.all(8.0),
                    ),
            ),
          ),
        ],
        title: const Text('Expenses',style:TextStyle(color: Color.fromARGB(255, 216, 216, 216)),),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        focusElevation: 2.0,
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddExpenseScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0, 1);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: isfetching
          ? const Center(
              child: CircularProgressIndicator(),
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
