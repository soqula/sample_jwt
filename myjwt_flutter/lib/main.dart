import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './menu.dart';
import './login.dart';
import './jwtprovider.dart';
import './list.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JwtProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MenuScreen(),
      routes: <String, WidgetBuilder>{
        '/menu': (BuildContext context) => const MenuScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/list': (BuildContext context) => const ListScreen(),
      },
    );
  }
}
