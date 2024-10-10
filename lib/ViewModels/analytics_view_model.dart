import 'package:expense_tracker/services/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';

// The ViewModel class for analytics
class AnalyticsViewModel extends StateNotifier<List<Expense>> {
  final FirestoreService _firestoreService;

  AnalyticsViewModel(this._firestoreService) : super([]) {
    // Load the expenses initially
    loadExpenses();
  }

  // Load expenses from Firestore
  void loadExpenses() {
    _firestoreService.getExpenses().listen((expenses) {
      state = expenses;
    });
  }

  // Function to group expenses by day of the week (Weekly View)
  List<double> getWeeklyExpenses() {
    List<double> weeklyExpenses = List.filled(7, 0);

    for (var expense in state) {
      // Get the weekday (Mon = 0, Tue = 1, etc.)
      int day = expense.date.weekday - 1;
      weeklyExpenses[day] += expense.amount;
    }

    return weeklyExpenses;
  }

  // Function to group expenses by month (Monthly View)
  List<double> getYearlyExpenses() {
    List<double> monthlyExpenses = List.filled(12, 0);

    for (var expense in state) {
      int month = expense.date.month - 1; // January = 0, February = 1, etc.
      monthlyExpenses[month] += expense.amount;
    }

    return monthlyExpenses;
  }

  // Function to generate the BarChartGroupData for the chart
  List<BarChartGroupData> getBarGroups(List<double> expenses) {
    return List.generate(expenses.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: expenses[index],
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }
}
