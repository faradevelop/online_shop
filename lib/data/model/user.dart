class UserEntity {
  final int id;
  final String name;
  final String mobile;

  // String? password;
  // String? passwordConfirmation;

  UserEntity(
    this.id,
    this.name,
    this.mobile,
    //this.password,
    // this.passwordConfirmation,
  );

  UserEntity.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    mobile = json['mobile'];
    //password = json['password']??"";
    // passwordConfirmation = json['password_confirmation']??"";

}
