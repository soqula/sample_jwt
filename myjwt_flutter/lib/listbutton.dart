import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './models.dart';

class WeightListButton extends StatelessWidget {
  const WeightListButton({Key? key, required this.index, required this.weight})
      : super(key: key);
  final int index;
  final HistoryWeight weight;
  @override
  Widget build(BuildContext context) {
    double tmpcolor =
        Theme.of(context).colorScheme.inversePrimary.computeLuminance();
    Color color = tmpcolor > 0.5 ? Colors.black : Colors.white;
    return ListTile(
      title: Text(
        DateFormat('yyyy-MM-dd').format(weight.saved_at).toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      subtitle: Text(
        "体重：${weight.weight}kg",
        style: TextStyle(color: color),
      ),
      leading: Icon(
        Icons.account_circle,
        color: color,
      ),
      tileColor: Colors.blue[100],
      onTap: () => {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => StockDetail(port: port),
        //   ),
        // ),
      },
      // onLongPress: () => {},
      // trailing: Icon(
      //   Icons.more_vert,
      //   color: color,
      // ),
      dense: true,
    );
  }
}
