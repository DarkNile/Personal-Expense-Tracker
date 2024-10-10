import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  ConsumerState<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  // Filter Variables
  int? selectedMonth;
  int? selectedYear;

  // Filter expenses by selected month and year
  void _filterExpenses() {
    if (selectedMonth != null && selectedYear != null) {
      ref
          .read(expenseProvider.notifier)
          .filterByMonth(selectedMonth!, selectedYear!, widget.expenses);
      // // Set filter by true
      ref.read(filteredProvider.notifier).state = true;
      // Pop up the filter dialog
      Navigator.of(context).pop();
    }
  }

  // Clear filter and show all expenses
  void _clearFilter() {
    ref.read(expenseProvider.notifier).clearFilter(widget.expenses);
    ref.read(selectedMonthProvider.notifier).state = null;
    ref.read(selectedYearProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    selectedMonth = ref.watch(selectedMonthProvider);
    selectedYear = ref.watch(selectedYearProvider);
    return AlertDialog(
      title: const Text(
        'Filter Expenses',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          // Month Dropdown
          DropdownButtonFormField<int>(
            value: selectedMonth,
            decoration: InputDecoration(
              labelText: 'Select Month',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            hint: const Text('Select Month'),
            items: List.generate(12, (index) => index + 1)
                .map<DropdownMenuItem<int>>(
                  (month) => DropdownMenuItem<int>(
                    value: month,
                    child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                  ),
                )
                .toList(),
            onChanged: (value) {
              ref.read(selectedMonthProvider.notifier).state = value;
            },
          ),
          const SizedBox(
            height: 48,
          ),
          // Year Dropdown
          DropdownButtonFormField<int>(
            value: selectedYear,
            decoration: InputDecoration(
              labelText: 'Select Year',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            hint: const Text('Select Year'),
            items: [2023, 2024]
                .map<DropdownMenuItem<int>>(
                  (year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              ref.read(selectedYearProvider.notifier).state = value;
            },
          ),
          const SizedBox(
            height: 48,
          ),
          ElevatedButton(
            onPressed: _filterExpenses,
            child: const Text('Filter'),
          ),
          if (selectedMonth != null || selectedYear != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
              ),
              child: TextButton(
                onPressed: _clearFilter,
                child: const Text('Clear Filter'),
              ),
            ),
        ],
      ),
    );
  }
}
