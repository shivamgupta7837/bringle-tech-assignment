import 'dart:convert';
import 'package:face_filter/data/login_model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {
  final String _isLogin = "IS_LOGIN";
  final String _loginDetails = "LOGIN_DETAILS";
  SharePreference._privateConstructor();

  static final SharePreference _instance =
      SharePreference._privateConstructor();

  static SharePreference get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setUserIsLogin() async {
  _prefs?.setBool(_isLogin, true);
  print("sharePf: is user login: ${await isUserLogin()}");
  }

  Future<bool?> isUserLogin() async {
    return _prefs?.getBool(_isLogin);
  }

  Future<bool> saveUserCredentials({required LoginModel loginModel}) async {
    print("Login share: ${jsonEncode(loginModel)}");
    final isSaved = await _prefs?.setString(
      _loginDetails,
      jsonEncode(loginModel.toJson()),
    );
    print("SDfsdafdasfsd isSaved: $isSaved");
   if(isSaved!=null){
     if (isSaved!) {
      print("saved");
     return true;
    } else {
      print("saved not");
      return false;
    }
   }else{
    print("saved null");
    return false;
   }
  }


  LoginModel? get loginDetails {
    final result = _prefs?.getString(_loginDetails);
    if (result != null) {
      return LoginModel.fromJson(jsonDecode(result));
    }
    return null;
  }

}
