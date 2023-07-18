import 'package:flutter/material.dart';
import './listbutton.dart';
import './jwtprovider.dart';
import 'package:provider/provider.dart';

class ListList extends StatefulWidget {
  const ListList({Key? key}) : super(key: key);
  @override
  _ListListState createState() => _ListListState();
}

class _ListListState extends State<ListList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JwtProvider>(
      builder: (context, jwtProvider, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jwtProvider.message,
                  style: const TextStyle(color: Colors.red),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: jwtProvider.weightList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(color: Colors.white, height: 10);
                    },
                    itemBuilder: (context, index) => WeightListButton(
                        index: index, weight: jwtProvider.weightList[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
