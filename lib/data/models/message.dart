class Message {
  int _id;
  String _name;
  String _message;

  Message(this._name, this._message);

  Message.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._message = obj['message'];
  }

  int get id => _id;
  String get name => _name;
  String get message => _message;

//  set id(int _id) => _id = _id;
//  set name(String _name) => _name = _name;
//  set name(String _name) => _name = _name;
//  set message(String _message) => _message = _message;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['message'] = _message;

    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._message = map['message'];
  }
}
