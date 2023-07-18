import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './models.dart';
import './alertdialog.dart';
import './jwtprovider.dart';

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
    return Consumer<JwtProvider>(
      builder: (context, jwtProvider, _) {
        return ListTile(
          title: Text(
            DateFormat('yyyy-MM-dd').format(weight.saved_at).toString(),
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
          onTap: () async {
            final result = await showDialog<int>(
                context: context,
                builder: (_) {
                  return AlearDialogButton();
                });
            print("選択は、${result}");
            if (result == 1) {
              await jwtProvider.delete(weight.id);
            }
          },
          dense: true,
        );
      },
    );
  }
}
