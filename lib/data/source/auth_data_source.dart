import 'package:dio/dio.dart';
import 'package:online_shop/common/http_response_validator.dart';
import 'package:online_shop/data/model/user.dart';
import 'package:online_shop/data/response/auth_info_response.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String mobile, String password);

  Future<AuthInfo> register(
      String name, String mobile, String password, String passwordConfirmation);

  Future<bool> editProfile(
      {required String name, String? oldPassword, String? newPassword});
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String mobile, String password) async {
    final res = await httpClient.post("/login", data: {
      "mobile": mobile,
      "password": password,
    });
    validateResponse(res);
    final UserEntity user = UserEntity.fromJson(res.data['user']);
    final AuthInfo authInfo = AuthInfo(
      token: res.data['token'],
      userName: user.name,
      userMobile: user.mobile,
    );
    return authInfo;
  }

  @override
  Future<AuthInfo> register(String name, String mobile, String password,
      String passwordConfirmation) async {
    final res = await httpClient.post("/register", data: {
      "name": name,
      "mobile": mobile,
      "password": password,
      "password_confirmation": passwordConfirmation,
    });
    validateResponse(res);
    return login(mobile, password);
  }

  @override
  Future<bool> editProfile(
      {required String name, String? oldPassword, String? newPassword}) async {
    var res = await httpClient.post("/profile", data: {
      "name": name,
      if (oldPassword != null && oldPassword.isNotEmpty)
        "old_password": oldPassword,
      if (newPassword != null && newPassword.isNotEmpty)
        "new_password": newPassword,
    });
    return res.statusCode == 200;
  }
}
