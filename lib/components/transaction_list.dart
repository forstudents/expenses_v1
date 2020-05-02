import 'package:expenses/components/transaction_item.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

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
                return TransactionItem(tr: tr, deleteTransaction: _deleteTransaction);
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
                      child: Text(''
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

