import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final void Function(String id) _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions != null && transactions.isNotEmpty
        ? Container(
            height: 300,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                // transactions.sort();
                final tr = transactions[index];
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
                            icon: Icon(Icons.delete),
                            label: Text('Excluir'),
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
              },
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              return Column(children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Container(
                      height: constraints.maxHeight * 0.15,
                      child: Text(
                        'Nenhuma transação cadastrada',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover),
                    )
                  ],
                )
              ]);
            },
          );
  }
}
