import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';

class ExpenseViewModel extends StateNotifier<List<Expense>> {
  final FirestoreService _firestoreService;

  ExpenseViewModel(this._firestoreService) : super([]) {
    // Load the expenses initially
    loadExpenses();
  }

  // Load expenses from Firestore
  void loadExpenses() {
    _firestoreService.getExpenses().listen((expenses) {
      state = expenses;
    });
  }

  // Add a new expense
  Future<void> addExpense(String title, double amount, DateTime date) async {
    final newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
    );
    await _firestoreService.addExpense(newExpense);
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    await _firestoreService.deleteExpense(id);
  }

  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    await _firestoreService.updateExpense(expense);
  }

  // Date Formatter
  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  // Filter expenses by month and year
  void filterByMonth(int month, int year, List<Expense> expenses) {
    final filteredExpenses = expenses.where((expense) {
      return expense.date.month == month && expense.date.year == year;
    }).toList();
    state = filteredExpenses;
  }

  // Clear the filter and show all expenses
  void clearFilter(List<Expense> expenses) {
    state = expenses;
  }
}
