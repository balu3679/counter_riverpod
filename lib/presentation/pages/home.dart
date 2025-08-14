import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/domain/utils/alerts.dart';
import 'package:messenger/presentation/pages/login.dart';
import '../providers/auth_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final logoutUseCase = ref.read(logoutUseCaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              bool resp = await Constants.showalert(
                context,
                title: 'Log out ?',
                subtitle: 'Are you sure want to logout',
              );
              if (resp) {
                await logoutUseCase();
                Constants.showtoast(context, message: 'Logout Successfully');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $counter', style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final current = ref.read(counterProvider);
                    if (current > 0) {
                      ref.read(counterProvider.notifier).state--;
                    }
                  },

                  child: const Text('Decrement'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state = 0,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
