import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/filter_provider.dart';
import 'package:expense_tracker/views/add_expense_screen.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:expense_tracker/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Expense Tracker',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddExpenseScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            // Check if Filter is opened or not
            if (ref.read(filteredProvider.notifier).state) {
              ref.read(expenseProvider.notifier).loadExpenses();
            } else {
              showDialog(
                context: context,
                builder: (ctx) {
                  return FilterWidget(expenses: expenses);
                },
              );
            }
            // Set filter by false
            ref.read(filteredProvider.notifier).state = false;
          },
          icon: Icon(
            ref.read(filteredProvider.notifier).state
                ? Icons.filter_alt_off
                : Icons.filter_alt,
          ),
        ),
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses found!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ExpenseItem(expense: expense);
              },
            ),
    );
  }
}
