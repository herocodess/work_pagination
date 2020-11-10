import 'dart:convert';

import 'package:flutter/foundation.dart';

ConnectModel payloadFromJson(String str) =>
    ConnectModel.fromJson(json.decode(str));

String payloadToJson(ConnectModel data) => json.encode(data.toJson());

class ConnectModel {
  ConnectModel({
    this.result,
  });

  Result result;

  factory ConnectModel.fromJson(Map<String, dynamic> json) => ConnectModel(
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
      };
}

class Result {
  Result({
    this.connect,
  });

  List<Connect> connect;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        connect: List<Connect>.from(
            json["connectUsers"].map((x) => Connect.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connectUsers": List<dynamic>.from(connect.map((x) => x.toJson())),
      };
}

class Connect with ChangeNotifier {
  Connect({
    this.id,
    this.name,
    this.userTag,
    this.university,
    this.checkIsFollowing,
    this.avatar,
  });
  String name;
  String userTag;
  String id;
  String university;
  String avatar;
  bool checkIsFollowing;

  factory Connect.fromJson(Map<String, dynamic> json) => Connect(
        id: json["_id"],
        name: json["name"],
        userTag: json["userTag"],
        university: json["userProfile"]["university"],
        checkIsFollowing: json["checkIsFollowing"],
        avatar: json["userProfile"]["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "userTag": userTag,
        "userProfile"
            "university": university,
        "userProfile"
            "avatar": avatar,
        "checkIsFollowing": checkIsFollowing
      };
}
