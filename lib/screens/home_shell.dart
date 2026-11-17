import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/design.dart';
import 'home_screen.dart';
import 'location_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenProfile: () => setState(() => _index = 3)),
          const LocationScreen(),
          const ScheduleScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        index: _index,
        onSelect: (index) => setState(() => _index = index),
        onStore: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ProductsScreen())),
      ),
    );
  }
}
