import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage the selected screen index in the BottomNavigationBar
final selectedIndexProvider = StateProvider<int>((ref) => 0);
