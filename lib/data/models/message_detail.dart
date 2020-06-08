class MessageDetail {
  int _id;
  int _msgId;
  String _name;
  String _message;
  int _msgIn;

  MessageDetail(this._msgId, this._name, this._message, this._msgIn);

  MessageDetail.map(dynamic obj) {
    this._id = obj['id'];
    this._msgId = obj['msgId'];
    this._name = obj['name'];
    this._message = obj['message'];
    this._msgIn = obj['msgIn'];
  }

  int get id => _id;
  int get msgId => _msgId;
  String get name => _name;
  String get message => _message;
  int get msgIn => _msgIn;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['msgId'] = _msgId;
    map['name'] = _name;
    map['message'] = _message;
    map['msgIn'] = _msgIn;

    return map;
  }

  MessageDetail.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._msgId = map['msgId'];
    this._name = map['name'];
    this._message = map['message'];
    this._msgIn = map['msgIn'];
  }
}
