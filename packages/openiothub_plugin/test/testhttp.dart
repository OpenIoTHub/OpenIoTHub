import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

main() async {
await postUriTest();
}

Future<void> getTest() async {
  String url = "http://127.0.0.1:54887/list";
  http.Response response;
  try {
    response = await http.get(url as Uri).timeout(const Duration(seconds: 2));
    print(response.body);
    Map<String, dynamic> rst = jsonDecode(response.body);
    if (rst["Code"] != 0) {
      print("rst[\"Code\"] != 0");
      return;
    }
    print(rst["OnvifDevices"]);
    List<dynamic> l = rst["OnvifDevices"];
    for (dynamic value in l) {
      print(value);
      print(value["Name"]);
    }
  } catch (e) {
    print(e.toString());
    return;
  }
}

Future<void> postTest() async {
  String url = "http://192.168.124.33/v1/users/login";
  Dio dio = Dio();
  try {
    final response = await dio.post(url, data: {'username': 'farry', 'password': 'RootRoot1'});
    print(response.data);
  } catch (e) {
    print(e.toString());
    return;
  }
}

Future<void> postUriTest() async {
  String uri = "/v1/users/login";
  Dio dio = Dio(BaseOptions(baseUrl: "http://192.168.124.33"));
  try {
    final response = await dio.postUri(Uri.parse(uri), data: {'username': 'farry', 'password': 'RootRoot'});
    print(response.data);
    Map<String, dynamic> data = response.data;
    print(data);
  } catch (e) {
    print(e.toString());
    return;
  }
}