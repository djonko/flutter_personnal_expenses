import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personnal_expend/chart.dart';
import 'package:personnal_expend/new_transaction.dart';
import 'transaction.dart';
import 'transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(
                  secondary: Colors.amber,
                  primary: Colors.purple // Your accent color
                  ),
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _useTransactions = [
    Transaction(
        id: 't1',
        date: DateTime.now().subtract(const Duration(days: 2)),
        title: "New shoes",
        amount: 69.99),
    Transaction(
        id: 't2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        title: "Weekly Groceries",
        amount: 16.53)
  ];

  List<Transaction> get _recentTransaction {
    var passed7Day = DateTime.now().subtract(const Duration(days: 7));
    return _useTransactions
        .where((element) => element.date.isAfter(passed7Day))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final tx = Transaction(
        id: dateTime.toString(), date: dateTime, title: title, amount: amount);
    setState(() {
      _useTransactions.add(tx);
    });
  }

  void _startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(addTransaction: _addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _useTransactions.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              CupertinoButton(
                onPressed: () {
                  _startAddTransaction(context);
                },
                child: const Icon(CupertinoIcons.add),
              )
            ]),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () {
                    _startAddTransaction(context);
                  },
                  icon: const Icon(Icons.add))
            ],
          ) as PreferredSizeWidget;
    final availableHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);
    //final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    final isLandscapeMode = mediaQuery.orientation == Orientation.landscape;

    chartBox(heightPct) {
      return SizedBox(
          height: availableHeight * heightPct,
          child: Chart(recentTransactions: _recentTransaction));
    }

    listTransactionBox(heightPct) {
      return SizedBox(
        height: availableHeight * heightPct,
        child: TransactionList(
          transactions: _useTransactions,
          deleteTransaction: _deleteTransaction,
        ),
      );
    }

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscapeMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscapeMode)
              Column(
                children: [chartBox(0.4), listTransactionBox(0.6)],
              ),
            if (isLandscapeMode)
              _showChart ? chartBox(0.8) : listTransactionBox(0.8)
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddTransaction(context);
                    },
                    child: const Icon(Icons.add),
                  ));
  }
}
