import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.isEditMode = false,
    this.expense,
  });

  final bool isEditMode;
  final Expense? expense;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  // Defining our Inputs Form Key
  final _formKey = GlobalKey<FormState>();

  // Defining TextFields Controllers
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  // Picked Calendar Date
  DateTime? _pickedDate;

  // Getting the expense for editing
  void _initExpense() {
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _dateController.text =
          ref.read(expenseProvider.notifier).formatDate(widget.expense!.date);
      _pickedDate = widget.expense!.date;
    }
  }

  @override
  void initState() {
    super.initState();
    _initExpense();
  }

  // Helper method to reset controllers
  void _resetControllers() {
    _titleController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _resetControllers();
  }

  // Adding or Editing Expense
  Future<void> _addExpense(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Saving my form inputs
    _formKey.currentState!.save();

    // Preparing our expense data
    String title = _titleController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;
    DateTime date = _pickedDate ?? DateTime.now();

    // If we are in editing mode and we have a ready exist expanse
    if (widget.isEditMode && widget.expense != null) {
      final newExpense = Expense(
        id: widget.expense!.id,
        title: title,
        amount: amount,
        date: date,
      );
      // Updating a ready exist expense
      await ref.read(expenseProvider.notifier).updateExpense(newExpense);
    } else {
      // Adding a new expense
      await ref.read(expenseProvider.notifier).addExpense(title, amount, date);
    }

    // Navigating back to our home screen
    Navigator.of(context).pop();
  }

  Future<void> _openCalendar(context) async {
    _pickedDate = await showDatePicker(
      context: context,
      initialDate:
          widget.expense != null ? widget.expense!.date : DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    // Format our picked date
    if (_pickedDate != null) {
      _dateController.text =
          ref.read(expenseProvider.notifier).formatDate(_pickedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting our screen height
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.isEditMode ? 'Update Expense' : 'Add Expense',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                onSaved: (newValue) {
                  _titleController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an expense title';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('Expense Title'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              TextFormField(
                controller: _amountController,
                onSaved: (newValue) {
                  _amountController.text = newValue!;
                },
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      double.tryParse(value)! <= 0.0) {
                    return 'Please enter a valid expense amount';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text('Expense Amount'),
                  border: const OutlineInputBorder(),
                  prefixText: '\$ ',
                  prefixStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _openCalendar(context),
                    icon: Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      onSaved: (newValue) {
                        _dateController.text = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please pickup an expense date';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Expense Date'),
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => _addExpense(context),
                child: Text(
                  widget.isEditMode ? 'Update' : 'Add',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
