import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './menu.dart';
import './login.dart';
import './jwtprovider.dart';
import './list.dart';
import './signup.dart';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp前にFlutter Engineを使う場合
  await dotenv.load(fileName: join("assets", '.env'));
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
        '/signup': (BuildContext context) => const SignupScreen(),
      },
    );
  }
}
