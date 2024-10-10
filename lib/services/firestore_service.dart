import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new expense to Firestore
  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('Expenses').add(expense.toMap());
  }

  // Fetch all expenses from Firestore
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('Expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Delete an expense from Firestore
  Future<void> deleteExpense(String id) async {
    await _firestore.collection('Expenses').doc(id).delete();
  }

  // Update an expense in Firestore
  Future<void> updateExpense(Expense expense) async {
    await _firestore
        .collection('Expenses')
        .doc(expense.id)
        .update(expense.toMap());
  }
}
