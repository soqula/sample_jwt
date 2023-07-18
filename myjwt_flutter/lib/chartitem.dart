import 'package:flutter/material.dart';
import './models.dart';
import 'package:intl/intl.dart';

List colorlist = [
  Colors.blue[200],
  Colors.yellow[200],
  Colors.red[200],
  Colors.green[200],
  Colors.purple[200],
  Colors.pink[200],
  Colors.orange[200],
  Colors.cyan[200],
  Colors.blue[100],
  Colors.yellow[100],
  Colors.red[100],
  Colors.green[100],
  Colors.purple[100],
  Colors.pink[100],
  Colors.orange[100],
  Colors.cyan[100],
  Colors.blue[50],
  Colors.yellow[50],
  Colors.red[50],
  Colors.green[50],
  Colors.purple[50],
  Colors.pink[50],
  Colors.orange[50],
  Colors.cyan[50],
];

class ChartItemButton extends StatelessWidget {
  const ChartItemButton({Key? key, required this.index, required this.weight})
      : super(key: key);
  final int index;
  final HistoryWeight weight;
  @override
  Widget build(BuildContext context) {
    double tmpcolor =
        Theme.of(context).colorScheme.inversePrimary.computeLuminance();
    Color color = tmpcolor > 0.5 ? Colors.black : Colors.white;
    return Card(
      borderOnForeground: true,
      color: colorlist[index % colorlist.length],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            height: 40,
            child: Text(
              DateFormat('yyyy-MM-dd').format(weight.saved_at).toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.center,
            height: 40,
            child: Text("体重：${weight.weight}kg",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
