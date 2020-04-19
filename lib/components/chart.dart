import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  // List<Map<String, Object>> get _groupedTransactions {
  //   return List.generate(7, (index) {
  //     print('teste111');
  //     return {'day': DateFormat.E().format(DateTime.now())[0], 'value': 10.0};
  //   });
  // }

  List<Map<String, Object>> get _groupedTransactions {
    initializeDateFormatting();
    return List.generate(7, (index) {

      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions[i].value;
        }
      }

      print('day: ${DateFormat.E().format(weekDay)[0]} value: $totalSum');
      
      return {'day': DateFormat.E('pt_BR').format(weekDay)[0], 'value': totalSum};
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return _groupedTransactions.fold(0.0, (sum, item) {
      return sum + item['value'];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: 
          _groupedTransactions.map((tr) {
            print('item ${tr['day']}');
            // return Text('teste');
           return  Expanded(
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage:   _weekTotalValue == 0 ? 0 : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
