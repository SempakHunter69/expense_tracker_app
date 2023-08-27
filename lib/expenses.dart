import 'package:expense_tracker_app/model/model_expense.dart';
import 'package:expense_tracker_app/widgets/widget_expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpansesState();
  }
}

class _ExpansesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 10.0,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Blue Beetle Movie',
      amount: 15.0,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const Text('The Cart'),
          Expanded(child: ExpensesList(expenses: _registeredExpenses)),
        ],
      ),
    ));
  }
}
