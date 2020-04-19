import 'dart:math';
import 'dart:io';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/chart.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: MyHomePage(),
        ),
      ),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18, //MediaQuery.of(context).textScaleFactor *
                  fontWeight: FontWeight.bold),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

/////
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: 't1',
    //     title: 'Tenis',
    //     value: 200.00,
    //     date: DateTime.now().subtract(Duration(days: 5))),
    // Transaction(
    //     id: 't2',
    //     title: 'IPTU',
    //     value: 120.00,
    //     date: DateTime.now().subtract(Duration(days: 2))),
    // Transaction(
    //     id: 't3',
    //     title: 'Condomínio',
    //     value: 340.00,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(
    //     id: 't4',
    //     title: 'Conta de Luz',
    //     value: 210.00,
    //     date: DateTime.now().subtract(Duration(days: 6))),
    // Transaction(
    //     id: 't5',
    //     title: 'Iptv',
    //     value: 30.00,
    //     date: DateTime.now().subtract(Duration(days: 7))),
    // Transaction(
    //     id: 't6',
    //     title: 'Conta de telefone',
    //     value: 40.00,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: 't7', title: 'Tenis preto', value: 200.00, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      print('addTransaction');
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(_addTransaction);
        });
  }


  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS ?
    GestureDetector(onTap: fn, child: Icon(icon),):
      IconButton(
            icon: Icon(icon),
            onPressed: () => fn,
          ); 
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    
    final iconChart = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions =  <Widget>[
        if (isLandscape)

          _getIconButton(_showChart ? iconList :iconChart, () {
             setState(() {
              _showChart = !_showChart;
            });
          }),

          _getIconButton(Platform.isIOS ? CupertinoIcons.add :  Icons.add, () => _openTransactionFormModal(context)),
      ];

    final PreferredSizeWidget appBar2 =  Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
    )) : AppBar(
      title: Text('Despesas Pessoais'),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar2.preferredSize.height -
        mediaQuery.padding.top;


    final bodyPage = SafeArea(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (_showChart || !isLandscape)
                    Container(
                      height: availableHeight * (isLandscape ? 0.7 : 0.3),
                      child: Chart(_recentTransactions),
                    ),
                  if (!_showChart || !isLandscape)
                    //  TransactionUser()
                    Container(
                      height: availableHeight * (isLandscape ? 1 : 0.7),
                      child: TransactionList(_transactions, _deleteTransaction),
                    ),
                ],
              ),
            ),);  

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar2 ,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar2,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
