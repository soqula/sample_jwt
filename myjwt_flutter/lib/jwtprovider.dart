import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import './models.dart';
import 'package:intl/intl.dart';

class JwtProvider with ChangeNotifier {
  bool _isSuccess = false;
  String message = '';
  String email = '';
  String password = '';
  bool hidePassword = true;
  int id = 0;
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
    id = 0;
    message = '';
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
      // idについても取得する
      final responseJwt2 = await dio.get('/api/myjwt/getid/',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${responseJwt.data['access']}',
            },
          ));
      cookieList = [
        ...cookieList,
        Cookie('access_token', responseJwt.data['access']),
        Cookie('access_id', responseJwt2.data['id'].toString()),
      ];
      id = responseJwt2.data['id'];
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
            id: response.data[index]['id'],
            userid: response.data[index]['user'],
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

  Future<void> addWeight(DateTime saved_at, double weigth) async {
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

      cookieList = await cookieJar.loadForRequest(_uriHost);

      final response = await dio.post(
        '/api/myjwt/myjwt/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${cookieList.first.value}',
          },
        ),
        data: {
          'user': cookieList[1].value,
          'saved_at': DateFormat('yyyy-MM-dd').format(saved_at).toString(),
          'weight': weigth,
        },
      );
      // データ取得しなおす
      await getlist();
      _isSuccess = true;
    } catch (error) {
      message = '登録に失敗しました。ログインしなおしてください';
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    PersistCookieJar cookieJar =
        PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
    await cookieJar.delete(_uriHost);
    notifyListeners();
  }

  Future<bool> getlist() async {
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

      cookieList = await cookieJar.loadForRequest(_uriHost);

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
            id: response.data[index]['id'],
            userid: response.data[index]['user'],
            saved_at: DateTime.parse(response.data[index]['saved_at']),
            weight: response.data[index]['weight'],
          );
        });
      }

      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  Future<void> delete(int id) async {
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

      cookieList = await cookieJar.loadForRequest(_uriHost);
      // deleteは、PKまで指定が必要。つけないと「not allowed」になってしまう。
      // /api/myjwt/myjwt/1/
      final response = await dio.delete(
        '/api/myjwt/myjwt/${id}/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${cookieList.first.value}',
          },
        ),
        data: {"id": id},
      );
      // データ取得しなおす
      await getlist();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
