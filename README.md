# Personal Expense Tracker

A simple personal expense tracker application built with Flutter. This app allows users to add, view, update, and delete their daily expenses. It also provides analytics features to visualize expenses over different periods.

## Features

- **Add Expense**: Users can add a new expense with a title, amount, and date.
- **View Expenses**: Display a list of all expenses, filtered by month if desired.
- **Update Expenses**: Users can update a ready existing expense with a title, amount, and date.
- **Delete Expense**: Users can swipe to delete expenses, with a confirmation dialog.
- **Filter Expenses**: Users can filter expenses by months and years.
- **Weekly Analytics**: Visualize weekly expenses using charts.
- **Monthly Analytics**: Visualize monthly expenses using charts.
- **Responsive Design**: Works well on both small and large screens.
- **Unit Testing**: Includes tests for expenses CRUD operations.

## Technologies Used

- Flutter
- Riverpod (State Management)
- MVVM (Architectural Pattern)
- Firestore (Database)
- fl_chart (Charts and Graphs)
- intl (Date Formatting)

## Installation

To run this application locally, follow these steps:

1. **Clone the repository**:

   git clone https://github.com/DarkNile/Personal-Expense-Tracker.git
   cd expense_tracker

2. **Make sure you have Flutter installed on your machine. Then, run**:

    flutter pub get

3. **You can run the app on an emulator or physical device using the following command in debug mode**:

    flutter run

4. **You can run the app on an emulator or physical device using the following command in release mode**:

    flutter run --release

5. **To run the unit tests, execute the following command**:

    flutter test