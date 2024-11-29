import 'package:client/core/providers/current_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
  class _HomePageState extends ConsumerState<HomePage>{
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    print(user);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/home_filled.png'), label: 'Home'),
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/library.png'), label: 'Library'),
      ]),
    );
  }
}

