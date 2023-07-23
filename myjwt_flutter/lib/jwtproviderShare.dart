import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import './models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShareAccess {
  // Uri _uriHost = Uri.parse('http://127.0.0.1:8000');
  Uri _uriHost =
      Uri.parse(dotenv.get("WEB_API", fallback: 'http://127.0.0.1:8000'));
  bool _isSuccess = false;
  String message = '';
  String email = '';
  String password = '';
  // int id = 0;
  List<HistoryWeight> _weightList = [];
  List<HistoryWeight> get weightList => _weightList;
  bool get isSuccess => _isSuccess;
  set uriHost(path) => _uriHost = path;

  ShareAccess();

  void clear() {
    email = '';
    password = '';
    message = '';
    print(dotenv.env["WEB_API"]);
  }

  Future<void> saveToken(String mode) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("access_token", mode);
  }

  Future<String> restoreToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("access_token") ?? "";
  }

  Future<void> saveId(String mode) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("access_id", mode);
  }

  Future<String> restoreId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("access_id") ?? "";
  }

  Future<bool> auth(String email, String password) async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.contentType = 'application/json';

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
      await saveToken(responseJwt.data['access']);
      await saveId(responseJwt2.data['id'].toString());
      // 一覧取得
      await getlist();
      _isSuccess = true;
    } catch (error) {
      message = '正しいEメールとパスワードを入力してください';
      print(error);
      _isSuccess = false;
    }
    return _isSuccess;
  }

  Future<bool> signup(String email, String password) async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.contentType = 'application/json';

      final responseJwt = await dio.post('/api/create/', data: {
        'email': email,
        'password': password,
      });
      // // idについても取得する
      // final responseJwt2 = await dio.get('/api/myjwt/getid/',
      //     options: Options(
      //       headers: {
      //         'Authorization': 'Bearer ${responseJwt.data['access']}',
      //       },
      //     ));
      // await saveToken(responseJwt.data['access']);
      // await saveId(responseJwt2.data['id'].toString());
      // // 一覧取得
      // await getlist();
      message = '登録しました。ログインしてください';
      _isSuccess = true;
    } catch (error) {
      message = '登録に失敗しました。';
      print(error);
      _isSuccess = false;
    }
    return _isSuccess;
  }

  Future<void> addWeight(DateTime saved_at, double weigth) async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.contentType = 'application/json';

      String strToken = await restoreToken();
      String id = await restoreId();

      final response = await dio.post(
        '/api/myjwt/myjwt/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $strToken',
          },
        ),
        data: {
          'user': id,
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
  }

  Future<void> logout() async {
    await saveToken("");
    await saveId("");
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

      String strToken = await restoreToken();

      final response = await dio.get(
        '/api/myjwt/myjwt/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $strToken',
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
        _weightList.sort(((a, b) => a.saved_at.compareTo(b.saved_at)));
      }

      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    return _isSuccess;
  }

  Future<void> delete(int id) async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.contentType = 'application/json';

      String strToken = await restoreToken();

      // deleteは、PKまで指定が必要。つけないと「not allowed」になってしまう。
      // /api/myjwt/myjwt/1/
      final response = await dio.delete(
        '/api/myjwt/myjwt/$id/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $strToken',
          },
        ),
        data: {"id": id},
      );
      // データ取得しなおす
      await getlist();
    } catch (e) {
      print(e);
    }
  }
}
