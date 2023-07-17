import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './jwtprovider.dart';
import './listbutton.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧表示'),
      ),
      body: Consumer<JwtProvider>(builder: (context, loginProvider, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loginProvider.message,
                  style: const TextStyle(color: Colors.red),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: loginProvider.weightList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(color: Colors.white, height: 10);
                    },
                    itemBuilder: (context, index) => WeightListButton(
                        index: index, weight: loginProvider.weightList[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
