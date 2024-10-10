import 'package:expense_tracker/ViewModels/analytics_view_model.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for AnalyticsViewModel
final analyticsViewModelProvider =
    StateNotifierProvider<AnalyticsViewModel, List<Expense>>((ref) {
  return AnalyticsViewModel(FirestoreService());
});

final analyticsToggleProvider = StateProvider<bool>((ref) {
  return true; // Initially show weekly view (true = weekly, false = monthly)
});
