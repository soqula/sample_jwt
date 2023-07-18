import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './jwtprovider.dart';
import 'package:intl/intl.dart';

class WeightAdd extends StatefulWidget {
  const WeightAdd({super.key});

  @override
  State<WeightAdd> createState() => _WeightAddState();
}

class _WeightAddState extends State<WeightAdd> {
  DateTime saved_at = DateTime.now();
  double weight = 0;

  @override
  Widget build(BuildContext context) {
    double tmpcolor =
        Theme.of(context).colorScheme.inversePrimary.computeLuminance();
    Color color = tmpcolor > 0.5 ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重履歴追加'),
      ),
      body: Container(
        height: 300.0,
        width: double.infinity,
        // color: Colors.blue,
        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          // border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Consumer<JwtProvider>(
          builder: (context, jwtprovider, child) {
            return Column(
              children: <Widget>[
                Text("体重履歴追加", style: TextStyle(color: color)),
                Spacer(),
                Spacer(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '日付${DateFormat('yyyy-MM-dd').format(saved_at).toString()}',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: saved_at,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              {
                                setState(() {
                                  saved_at = selectedDate;
                                });
                              }
                            }
                          })
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(flex: 1),
                    Flexible(
                        child: TextField(
                      decoration: InputDecoration(
                          labelText: '体重：',
                          labelStyle: TextStyle(color: color)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => {
                        if (int.tryParse(value) != null)
                          {
                            weight = double.parse(value),
                          }
                      },
                    )),
                    Text(
                      'kg',
                      style: TextStyle(fontSize: 18, color: color),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
                Spacer(flex: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('追加', style: TextStyle(color: color)),
                      onPressed: () => {
                        jwtprovider.addWeight(saved_at, weight),
                        Navigator.pop(context),
                      },
                    ),
                    ElevatedButton(
                      child: Text('キャンセル', style: TextStyle(color: color)),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                  ],
                ),
                Spacer(flex: 7),
              ],
            );
          },
        ),
      ),
    );
  }
}
