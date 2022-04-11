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
    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
            onPressed: () {
              _startAddTransaction(context);
            },
            icon: const Icon(Icons.add))
      ],
    );
    final availableHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    //final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    final isLandscapeMode =
        MediaQuery.of(context).orientation == Orientation.landscape;

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

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscapeMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show Chart'),
                    Switch(
                        value: _showChart,
                        onChanged: (value) {
                          setState(() {
                            _showChart = value;
                          });
                        })
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _startAddTransaction(context);
          },
          child: const Icon(Icons.add),
        ));
  }
}
