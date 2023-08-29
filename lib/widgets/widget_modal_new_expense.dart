import 'dart:io';

import 'package:expense_tracker_app/model/model_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpenseModal extends StatefulWidget {
  const NewExpenseModal({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpenseModal> createState() {
    return _NewExpenseModal();
  }
}

class _NewExpenseModal extends State<NewExpenseModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final todayDate = DateTime.now();
    final firstDate =
        DateTime(todayDate.year - 10, todayDate.day, todayDate.day);
    final lastDate = todayDate;
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: todayDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text('Invalid input'),
            content: const Text(
                'Please make sure a valid title, amount, date and category was entered'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid input'),
            content: const Text(
                'Please make sure a valid title, amount, date and category was entered'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              )
            ],
          );
        },
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //show error message
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        // print(constraints.minWidth);
        // print(constraints.maxWidth);
        // print(constraints.minHeight);
        // print(constraints.maxHeight);

        var width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 50, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amout'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected yet'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: () {
                                  _presentDatePicker();
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amout'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected yet'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: () {
                                  _presentDatePicker();
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
