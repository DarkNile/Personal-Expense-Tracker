import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for selected month and year
final selectedMonthProvider = StateProvider<int?>((ref) => null);
final selectedYearProvider = StateProvider<int?>((ref) => null);

// Provider to check if the filter popup is open or not
final filteredProvider = StateProvider<bool>((ref) => false);
