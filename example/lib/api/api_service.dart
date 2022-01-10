import 'dart:async';
import 'dart:convert';

import 'package:argear_flutter_plugin_example/config.dart';
import 'package:http/http.dart' show Client, Response;

import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

class ApiService {
  Client client = Client();

  final _baseUrl = Config.apiUrl;
  final _apiKey = Config.apiKey;
  final _path = '/api/v3/';

  Future<ContentsModel> fetchMain() async {
    final uri = Uri.parse('$_baseUrl$_path$_apiKey?dev=true');

    Response response;
    response = await client.get(uri);

    if (response.statusCode == 200) {
      return ContentsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
