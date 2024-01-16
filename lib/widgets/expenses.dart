import 'package:expenses_trancker/model/expense.dart';
// import 'package:expenses_trancker/widgets/chart/chart.dart';
import 'package:expenses_trancker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_trancker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Travel",
      amount: 20.0,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: "Cinema",
      amount: 23.0,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
    // builder: (context) => const Wrap(children: [NewExpense()]));
  }
  //add new list from form

  void _addExpense(Expense expense) {
    //it must should be excuted in newExpense
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();//used to remove immediately message which was shown
    ScaffoldMessenger.of(context).showSnackBar( //showing message swap and remove items and undo item
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          "Expense deleted",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.green,
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense); //insert most contain index(ID) and Element
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{");
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    print("}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");

    Widget mainContent = const Center(
      child: Text(
        "No Expenses found! start adding some!",
        style: TextStyle(fontSize: 18),
      ),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return (Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        // backgroundColor: const Color.fromARGB(255, 19, 3, 138),
        actions: [
          IconButton(
            onPressed: () {
              _openAddExpensesOverlay();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text(
          "Expenses Tracker",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Text("data"),
        // Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    ));
  }
}
