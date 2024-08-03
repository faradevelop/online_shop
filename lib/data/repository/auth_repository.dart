import 'package:flutter/cupertino.dart';
import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/response/auth_info_response.dart';
import 'package:online_shop/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String mobile, String password);

  Future<void> logOut();

  Future<void> register(
      String name, String mobile, String password, String passwordConfirmation);

  Future<bool> editProfile(
      {required String name, String? oldPassword, String? newPassword});
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);

  AuthRepository(this.dataSource);

  @override
  Future<void> login(String mobile, String password) async {
    final AuthInfo authInfo = await dataSource.login(mobile, password);
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> register(String name, String mobile, String password,
      String passwordConfirmation) async {
    final AuthInfo authInfo =
        await dataSource.register(name, mobile, password, passwordConfirmation);
    _persistAuthToken(authInfo);
  }

  Future<void> _persistAuthToken(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (authInfo.token.isNotEmpty) {
      sharedPreferences.setString("token", authInfo.token);
      sharedPreferences.setString('username', authInfo.userName);
      sharedPreferences.setString('mobile', authInfo.userMobile);
    }
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String token = sharedPreferences.getString("token") ?? "";

    if (token.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(
          token: token,
          userName: sharedPreferences.getString("username") ?? "",
          userMobile: sharedPreferences.getString("mobile") ?? "");
    }
  }

  @override
  Future<void> logOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }

  @override
  Future<bool> editProfile(
      {required String name, String? oldPassword, String? newPassword}) async {
    final res = await dataSource.editProfile(
        name: name, oldPassword: oldPassword, newPassword: newPassword);
    if (res) {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('username', name);
    }
    loadAuthInfo();
    return res;
  }
}
