import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    final isLoading = auth.isLoading;
    bool isDarkMode(BuildContext context) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDarkMode(context)
                ? Theme.of(context).colorScheme.onInverseSurface
                : Theme.of(context).colorScheme.surfaceTint,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'lib/assets/images/wallet-8184645_1280.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    hintText: 'Email id',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 174, 174, 174),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    hintText: 'Password ',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 174, 174, 174),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          await auth.signIn(email.text, password.text, context);
                        },
                        child: Text(
                          'login',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize),
                        )),
                    const Text(
                      '/',
                      style: TextStyle(fontSize: 40, color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () async {
                          await auth.signUp(email.text, password.text, context);
                        },
                        child: Text(
                          'signIn',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize),
                        )),
                    const Text(
                      '/',
                      style: TextStyle(fontSize: 40, color: Colors.grey),
                    ),
                    // const GoogleAuthScreen(),
                    InkWell(
                      onTap: () async {
                        await auth.signInUsingGoogle(context);
                      },
                      child: SizedBox(
                        width: 28,
                        height: 22,
                        child: Image.asset(
                          'lib/assets/images/google.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
