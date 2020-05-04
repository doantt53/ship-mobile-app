import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ResLogin {
  ResLogin({
    this.UserID,
    this.Fullname,
    this.LoginStatus,
    this.Msg
  });

  @JsonKey(name: "UserID")
  final int UserID;

  @JsonKey(name: "Fullname")
  final String Fullname;

  @JsonKey(name: "LoginStatus")
  final int LoginStatus;

  @JsonKey(name: "Msg")
  final String Msg;

  factory ResLogin.fromJson(Map<String, dynamic> json) => _$ResLoginFromJson(json);

  Map<String, dynamic> toJson() => _$ResLoginToJson(this);

  @override
  String toString() {
    return "$UserID $Fullname".toString();
  }

  static ResLogin _$ResLoginFromJson(Map<String, dynamic> json) {
    return ResLogin(
        UserID: json['UserID'] as int,
        Fullname: json['Fullname'] as String,
        LoginStatus: json['LoginStatus'] as int,
        Msg: json['Msg'] as String);
  }

  static Map<String, dynamic> _$ResLoginToJson(ResLogin instance) => <String, dynamic>{
    'UserID': instance.UserID,
    'Fullname': instance.Fullname,
    'LoginStatus': instance.LoginStatus,
    'Msg': instance.Msg
  };
}
