import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnal_expend/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      return {'day': DateFormat.E(weekday), 'amount': 9.99};
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: const Row(
        children: [],
      ),
    );
  }
}
