import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import './transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        final tx = recentTransactions[i];
        if (tx.date.day == weekday.day &&
            tx.date.month == weekday.month &&
            tx.date.year == weekday.year) {
          totalSum += tx.amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupTransactionValues.fold(0.0,
        (calculetedSum, item) => calculetedSum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransactionValues.map((e) {
              final day = e['day'].toString();
              final amount = (e['amount'] as double);
              final spendingPctOfTotal =
                  totalSpending > 0.0 ? amount / totalSpending : 0.0;
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: day,
                    spendingAmount: amount,
                    spendingPctOfTotal: spendingPctOfTotal),
              );
            }).toList()),
      ),
    );
  }
}
