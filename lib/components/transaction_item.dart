import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.tr,
    @required void Function(String id) deleteTransaction,
  }) : _deleteTransaction = deleteTransaction, super(key: key);

  final Transaction tr;
  final void Function(String id) _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text('R\$${tr.value}')),
          ),
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(tr.date),
          style: Theme.of(context).textTheme.title,
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                onPressed: () => _deleteTransaction(tr.id),
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteTransaction(tr.id);
                },
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}