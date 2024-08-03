
class AuthInfo {
  final String userName;
  final String userMobile;
  final String token;

  AuthInfo(
      {required this.userName, required this.userMobile, required this.token});
/*

  AuthInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ?  UserEntity.fromJson(json['user']) : null;
    token = json['token'];
  }
*/
}
