import 'package:expense_tracker/providers/navigation_provider.dart';
import 'package:expense_tracker/views/analytics_screen.dart';
import 'package:expense_tracker/views/expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // List of the screens for each tab
  static const List<Widget> _screens = <Widget>[
    ExpensesScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected index from the provider
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      body: _screens[selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: selectedIndex,
        selectedItemColor: Colors.indigo[700],
        onTap: (index) {
          // Update the selected index of the screen
          ref.read(selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
