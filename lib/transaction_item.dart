import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaction.dart';

class TransactionItem extends StatelessWidget {
  final Function deleteTransaction;
  final Transaction transaction;
  const TransactionItem(
      {Key? key, required this.transaction, required this.deleteTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    iconButtonDelete(String id) {
      return IconButton(
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).errorColor,
        ),
        onPressed: () {
          deleteTransaction(id);
        },
      );
    }

    iconTextButtonDelete(String id) {
      return TextButton.icon(
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).errorColor,
        ),
        label: Text(
          'Delete',
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
        onPressed: () {
          deleteTransaction(id);
        },
      );
    }

    return Card(
      key: Key(transaction.id),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(transaction.title,
            style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? iconTextButtonDelete(transaction.id)
            : iconButtonDelete(transaction.id),
      ),
    );
  }
}
