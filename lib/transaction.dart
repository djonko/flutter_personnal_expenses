class Transaction {
  final double amount;
  final DateTime date;
  final String id;
  final String title;

  Transaction(
      {required this.id,
      required this.date,
      required this.title,
      required this.amount});
}
