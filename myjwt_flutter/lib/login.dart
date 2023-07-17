import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './jwtprovider.dart';
import './list.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインページ'),
      ),
      body: Consumer<JwtProvider>(builder: (context, loginProvider, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (value) => loginProvider.email = value,
                  decoration: const InputDecoration(
                    labelText: 'email',
                  ),
                ),
                Text(
                  loginProvider.message,
                  style: const TextStyle(color: Colors.red),
                ),
                TextFormField(
                  onChanged: (value) => loginProvider.password = value,
                  decoration: InputDecoration(
                    labelText: 'password',
                    suffixIcon: IconButton(
                        onPressed: () => loginProvider.togglePasswordVisible(),
                        icon: const Icon(Icons.remove_red_eye)),
                  ),
                  obscureText: loginProvider.hidePassword,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      loginProvider.setMessage('');
                      loginProvider.auth().then((isSuccess) {
                        if (isSuccess) {
                          loginProvider.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListScreen()),
                            (route) => false,
                          );
                        }
                      }).catchError((e) => print(e));
                    },
                    child: const Text('ログイン'),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
