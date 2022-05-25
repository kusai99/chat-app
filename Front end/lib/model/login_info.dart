class login_info {
  int id;
  String jwt;

  login_info.fromJson(Map json)
      : id = json['id'],
        jwt = json['jwt'];

  Map toJson() {
    return {'id': id, 'jwt' : jwt};
  }
}
