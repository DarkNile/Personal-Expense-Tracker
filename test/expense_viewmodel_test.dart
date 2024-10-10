import 'package:expense_tracker/ViewModels/expense_view_model.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_firestore_service.dart';

void main() {
  late ExpenseViewModel expenseViewModel;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    expenseViewModel = ExpenseViewModel(mockFirestoreService);
  });

  test('Initial state is empty', () {
    expect(expenseViewModel.state, isEmpty);
  });

  test('Adds an expense', () async {
    final expense = Expense(
      title: 'Lunch',
      amount: 50.0,
      date: DateTime.now(),
    );

    await expenseViewModel.addExpense(
        expense.title, expense.amount, expense.date);

    expect(expenseViewModel.state.length, 1);
    expect(expenseViewModel.state[0].title, 'Lunch');
    expect(expenseViewModel.state[0].amount, 50.0);
  });

  test('Updates an expense', () async {
    final expense = Expense(
      title: 'Lunch',
      amount: 50.0,
      date: DateTime.now(),
    );

    await expenseViewModel.addExpense(
        expense.title, expense.amount, expense.date);

    final updatedExpense = Expense(
      id: expenseViewModel.state[0].id, // Use the ID from the added expense
      title: 'Dinner',
      amount: 60.0,
      date: expense.date,
    );

    await expenseViewModel.updateExpense(updatedExpense);

    expect(expenseViewModel.state[0].title, 'Dinner');
    expect(expenseViewModel.state[0].amount, 60.0);
  });

  test('Deletes an expense', () async {
    final expense = Expense(
      title: 'Lunch',
      amount: 50.0,
      date: DateTime.now(),
    );

    await expenseViewModel.addExpense(
        expense.title, expense.amount, expense.date);

    // Verify the expense is added
    expect(expenseViewModel.state.length, 1);

    // Now delete the expense
    await expenseViewModel.deleteExpense(expenseViewModel.state[0].id!);

    expect(expenseViewModel.state, isEmpty);
  });

  test('Does not update non-existent expense', () async {
    final nonExistentExpense = Expense(
      id: 'nonexistent_id',
      title: 'Fake Expense',
      amount: 100.0,
      date: DateTime.now(),
    );

    await expenseViewModel.updateExpense(nonExistentExpense);

    // The state should still be empty since we never added this expense
    expect(expenseViewModel.state, isEmpty);
  });
}
