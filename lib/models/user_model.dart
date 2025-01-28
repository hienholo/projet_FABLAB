/// id : 1
/// name : "Leanne Graham"
/// username : "Bret"
/// email : "Sincere@april.biz"
/// address : {"street":"Kulas Light","suite":"Apt. 556","city":"Gwenborough","zipcode":"92998-3874","geo":{"lat":"-37.3159","lng":"81.1496"}}
/// phone : "1-770-736-8031 x56442"
/// website : "hildegard.org"
/// company : {"name":"Romaguera-Crona","catchPhrase":"Multi-layered client-server neural-net","bs":"harness real-time e-markets"}

class UserModel {
  UserModel(
      {int? id,
      String? username,
      String? password,
      bool? allowed,
      String? role}) {
    _id = id;
    _username = username;
    _password = password;
    _allowed = allowed;
    _role = role;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _password = json['password'];
    _allowed = json['allowed'];
    _role = json['role'];
  }
  int? _id;
  String? _username;
  String? _password;
  String? _role;
  bool? _allowed;

  changePrivilege() {
    if (_allowed == null || _allowed == false) {
      _allowed = true;
    } else {
      _allowed = false;
    }
  }

  bool isAdmin() {
    if (_role?.toLowerCase() == "admin") {
      return true;
    } else {
      return false;
    }
  }

  int? get id => _id;
  String? get username => _username;
  String? get role => _role;
  String? get password => _password;
  bool? get allowed => _allowed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['password'] = _password;
    map['role'] = _role;
    map['allowed'] = _allowed;
    return map;
  }

  void setId(int id) {
    _id = id;
  }

  void setRole(String role) {
    _role = role;
  }

  void setUsername(String username) {
    _username = username;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setAllowed(bool allowed) {
    _allowed = allowed;
  }
}
