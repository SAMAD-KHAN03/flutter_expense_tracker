import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_expenses/animations/slide_transition.dart';
import 'package:my_expenses/providers/auth_provider.dart';
import 'package:my_expenses/providers/user_profile_provider.dart';
import 'package:my_expenses/screens/expense_screen.dart';
import 'package:my_expenses/screens/profile_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final uid = ref.read(authenticationProvider.notifier).uid();
    ref.read(userProfileProvider.notifier).fetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final auth = ref.watch(authenticationProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: false,
          title: const Text(
            'DashBoard',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null ? 'Hi,${user.name.split(' ')[0]}' : 'Hi',
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'What would you like to do?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: courseLayout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget courseLayout(BuildContext context) {
  List<String> imageFileList = [
    '—Pngtree—money bag vector_9168976.png',
    '—Pngtree—man avatar image for profile_13001882.png',
  ];
  List<String> textList = [
    "See Expenses",
    "see Profile",
  ];
  List<Widget> functionality = const [
    ExpenseScreen(),
    ProfilePage(),
  ];
  return MasonryGridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 27,
    crossAxisSpacing: 23,
    itemCount: imageFileList.length,
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            SlideTransitionUtil.slideTransition(functionality[index]),
          );
        },
        child: Column(children: [
          Text(
            textList[index],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'lib/assets/images/${imageFileList[index]}',
              fit: BoxFit.cover,
            ),
          ),
        ]),
      );
    },
  );
}
