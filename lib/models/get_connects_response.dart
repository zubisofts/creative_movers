// To parse this JSON data, do
//
//     final fetchConnectionResponse = fetchConnectionResponseFromJson(jsonString);

import 'dart:convert';

FetchConnectionResponse fetchConnectionResponseFromJson(String str) => FetchConnectionResponse.fromJson(json.decode(str));

String fetchConnectionResponseToJson(FetchConnectionResponse data) => json.encode(data.toJson());

class FetchConnectionResponse {
  FetchConnectionResponse({
    required this.connections,
  });

  Connections connections;

  factory FetchConnectionResponse.fromJson(Map<String, dynamic> json) => FetchConnectionResponse(
    connections: Connections.fromJson(json["connections"]),
  );

  Map<String, dynamic> toJson() => {
    "connections": connections.toJson(),
  };
}

class Connections {
  Connections({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int? from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Connections.fromJson(Map<String, dynamic> json) => Connections(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  Datum({
    this.id,
    this.myId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.role,
    required this.firstname,
    required this.lastname,
    required this.profilePhotoPath,
    required this.connects,
  });

  int? id;
  int? myId;
  int userId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String username;
  String role;
  String firstname;
  String lastname;
  String profilePhotoPath;
  List<Connect> connects;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    myId: json["my_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    username: json["username"],
    role: json["role"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    profilePhotoPath: json["profile_photo_path"],
    connects: List<Connect>.from(json["connects"].map((x) => Connect.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "my_id": myId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "username": username,
    "role": role,
    "firstname": firstname,
    "lastname": lastname,
    "profile_photo_path": profilePhotoPath,
    "connects": List<dynamic>.from(connects.map((x) => x.toJson())),
  };
}

class Connect {
  Connect({
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.profilePhotoPath,
  });

  String firstname;
  String lastname;
  String role;
  String profilePhotoPath;

  factory Connect.fromJson(Map<String, dynamic> json) => Connect(
    firstname: json["firstname"],
    lastname: json["lastname"],
    role: json["role"],
    profilePhotoPath: json["profile_photo_path"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "role": role,
    "profile_photo_path": profilePhotoPath,
  };
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}