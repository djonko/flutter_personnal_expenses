import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
              child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: const EdgeInsets.all(10),
                child: Text('\$${tx.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    DateFormat.yMMMd().format(tx.date),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ));
        },
        itemCount: transactions.length,
      ),
    );
  }
}
