import 'dart:convert';

List<Message> todoFromJson(String str) => new List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String todoToJson(List<Message> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  int id;
  DateTime createdAt;
  String content;
  String phone;
  bool status;

  Message({
    this.createdAt,
    this.id,
    this.content,
    this.phone,
    this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) => new Message(
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    content: json["content"],
    phone: json["phone"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "content": content,
    "phone": phone,
    "status": status,
  };
}