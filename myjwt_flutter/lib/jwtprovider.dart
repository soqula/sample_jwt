import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import './models.dart';

class JwtProvider with ChangeNotifier {
  bool _isSuccess = false;
  String message = '';
  String email = '';
  String password = '';
  bool hidePassword = true;
  List<HistoryWeight> _weightList = [];
  List<HistoryWeight> get weightList => _weightList;

  final Uri _uriHost = kIsWeb
      ? Uri.parse('http://127.0.0.1:8000')
      : Uri.parse('http://10.0.2.2:8000');

  void setMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  void togglePasswordVisible() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void clear() {
    email = '';
    password = '';
  }

  Future<bool> auth() async {
    _isSuccess = false;
    message = '';

    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.contentType = 'application/json';

      List<Cookie> cookieList = [];

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      PersistCookieJar cookieJar =
          PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
      dio.interceptors.add(CookieManager(cookieJar));

      final responseJwt = await dio.post('/api/token/', data: {
        'email': email,
        'password': password,
      });
      cookieList = [
        ...cookieList,
        Cookie('access_token', responseJwt.data['access'])
      ];
      await cookieJar.saveFromResponse(_uriHost, cookieList);

      final response = await dio.get(
        '/api/myjwt/myjwt/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${cookieList.first.value}',
          },
        ),
      );
      if (response.statusCode == 200) {
        _weightList = List.generate(response.data.length, (index) {
          return HistoryWeight(
            id: response.data[index]['user'],
            saved_at: DateTime.parse(response.data[index]['saved_at']),
            weight: response.data[index]['weight'],
          );
        });
      }

      _isSuccess = true;
    } catch (error) {
      message = '正しいEメールとパスワードを入力してください';
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  Future<void> logout() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    PersistCookieJar cookieJar =
        PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
    await cookieJar.delete(_uriHost);
    notifyListeners();
  }
}
