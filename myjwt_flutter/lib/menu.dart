import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重記録アプリ'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '記録をしましょう！',
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            child: const Text('ログイン'),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      )),
    );
  }
}
