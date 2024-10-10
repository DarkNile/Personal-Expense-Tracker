import 'package:expense_tracker/ViewModels/expense_view_model.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the ExpenseViewModel
final expenseProvider =
    StateNotifierProvider<ExpenseViewModel, List<Expense>>((ref) {
  return ExpenseViewModel(FirestoreService());
});
