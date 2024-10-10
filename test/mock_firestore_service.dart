import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class MockFirestoreService implements FirestoreService {
  final List<Expense> _expenses = [];

  // Retrieve expenses
  @override
  Stream<List<Expense>> getExpenses() {
    return Stream.value(_expenses);
  }

  // Add an expense
  @override
  Future<void> addExpense(Expense expense) async {
    final newExpense = Expense(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Generate a unique ID
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
    );
    _expenses.add(newExpense);
  }

  // Delete an expense
  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
  }

  // Update an expense
  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense; // Update the existing expense
    }
  }
}
