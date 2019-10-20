class Connection {
  String name;
  String address;
  String port;
  String username;
  String passwordOrKey;
  String path;

  Connection({
    this.name = "",
    this.address,
    this.port = "22",
    this.username = "",
    this.passwordOrKey = "",
    this.path = "~",
  });

  void setter(String key, String value) {
    switch (key) {
      case "name":
        name = value;
        break;
      case "address":
        address = value;
        break;
      case "port":
        port = value;
        break;
      case "username":
        username = value;
        break;
      case "passwordOrKey":
        passwordOrKey = value;
        break;
      case "path":
        path = value;
        break;
    }
  }

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      name: map["name"] ?? "",
      address: map["address"],
      port: map["port"] != null && map["port"] != "" ? map["port"] : "22",
      username: map["username"] ?? "",
      passwordOrKey: map["passwordOrKey"] ?? "",
      path: map["path"] ?? "~",
    );
  }

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      name: json["name"],
      address: json["address"],
      port: json["port"],
      username: json["username"],
      passwordOrKey: json["passwordOrKey"],
      path: json["path"],
    );
  }

  Map<String, String> toMap() {
    return {
      "name": name,
      "address": address,
      "port": port,
      "username": username,
      "passwordOrKey": passwordOrKey,
      "path": path,
    };
  }

  @override
  String toString() {
    return "Connection [" +
        "name:$name, " +
        "address:$address, " +
        "port:$port, " +
        "username:$username, " +
        "passwordOrKey:$passwordOrKey, " +
        "path:$path]";
  }
}
