import 'package:flutter/foundation.dart';
import './models.dart';
import './jwtproviderDio.dart';
import './jwtproviderShare.dart';

class JwtProvider with ChangeNotifier {
  bool _isSuccess = false;
  String message = '';
  String email = '';
  String password = '';
  bool hidePassword = true;
  // int id = 0;
  // List<HistoryWeight> _weightList = [];

  List<HistoryWeight> get weightList {
    if (kIsWeb) {
      return shareaccess.weightList;
    } else {
      return dioaccess.weightList;
    }
  }

  DioAccess dioaccess = DioAccess();
  ShareAccess shareaccess = ShareAccess();

  void setMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  void togglePasswordVisible() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  double getMaxWeight() {
    if (weightList.isEmpty) {
      return 0;
    }
    double value = 0.0;
    weightList.forEach((element) {
      if (value < element.weight) {
        value = element.weight;
      }
    });
    return value;
  }

  double getMinWeight() {
    if (weightList.isEmpty) {
      return 0;
    }
    double value = 200.0;
    weightList.forEach((element) {
      if (value > element.weight) {
        value = element.weight;
      }
    });
    return value;
  }

  void clear() {
    shareaccess.clear();
    dioaccess.clear();
  }

  Future<bool> auth() async {
    _isSuccess = false;
    message = '';
    if (kIsWeb) {
      _isSuccess = await shareaccess.auth(email, password);
    } else {
      _isSuccess = await dioaccess.auth(email, password);
    }

    notifyListeners();
    return _isSuccess;
  }

  Future<void> addWeight(DateTime saved_at, double weigth) async {
    if (kIsWeb) {
      await shareaccess.addWeight(saved_at, weigth);
      _isSuccess = shareaccess.isSuccess;
    } else {
      await dioaccess.addWeight(saved_at, weigth);
      _isSuccess = dioaccess.isSuccess;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    if (kIsWeb) {
      await shareaccess.logout();
    } else {
      await dioaccess.logout();
    }
    notifyListeners();
  }

  Future<bool> getlist() async {
    _isSuccess = false;
    message = '';
    if (kIsWeb) {
      await shareaccess.getlist();
      _isSuccess = shareaccess.isSuccess;
    } else {
      await dioaccess.getlist();
      _isSuccess = dioaccess.isSuccess;
    }

    return _isSuccess;
  }

  Future<void> delete(int id) async {
    if (kIsWeb) {
      await shareaccess.delete(id);
      _isSuccess = shareaccess.isSuccess;
    } else {
      await dioaccess.delete(id);
      _isSuccess = dioaccess.isSuccess;
    }

    notifyListeners();
  }
}
