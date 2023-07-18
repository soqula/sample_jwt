import 'package:flutter/material.dart';

class AlearDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('確認'),
      content: Text('削除していいですか？'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(1),
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(0),
        ),
      ],
    );
  }
}
