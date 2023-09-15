import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:crypto/crypto.dart';

createHmac(String secreteKey, String jsonPayloadObj) {
  var key = utf8.encode(secreteKey);
  var bytes = utf8.encode(jsonPayloadObj);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);
  var hmac = base64Encode(digest.bytes).toString();
  return (hmac);
  //return digest;
  //print("HMAC digest as bytes: ${digest.bytes}");
  //print("HMAC digest as hex string: $digest");
}

generatoken(String siteid, String sitename, String key) async {
  //print('generate function call');
  var thmac = createHmac(key, 'abc@gmail.com');

  final jwt = JWT(
      // Payload
      {"sub": sitename, "exp": 1976681470, "site_id": siteid, "hmac": thmac});

  final jwtheader = <String, String>{'alg': 'HS256', 'typ': 'JWT'};

  //print(jwtheader);
  JWT(jwtheader);

  //jwt.header(jwtheader);
  //key = base64Encode(key);
  key = base64Encode(utf8.encode(key));
// Sign it (default with HS256 algorithm)
  final token = jwt.sign(SecretKey(key));
  //print(token);

  var url =
      'https://s15.socialannexuat.net/api/3.0/users/test.uat.10001062@gmail.com';

  final Map<String, dynamic> payload = {
    'param1': 'value1',
    'param2': 'value2',
  };

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    //body: jsonEncode(payload), // Encode the payload as JSON
  );
  //print('Token : ${token}');
  print(response.body.toString());
}

class CallingApi extends StatefulWidget {
  const CallingApi({super.key});

  @override
  State<CallingApi> createState() => _CallingApiState();
}

class _CallingApiState extends State<CallingApi> {
  final url = "https://jsonplaceholder.typicode.com/todos";
  var data;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var uri = await http.get(Uri.http('jsonplaceholder.typicode.com', 'todos'));
    var sitename = "DhirajDev";
    var siteid = "128250540";
    var skey = "AfNZwT4iKUv6AZxly9EGvmk69qmd9C0u";
    generatoken(siteid, sitename, skey);

    if (uri.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      data = jsonDecode(uri.body);
      // print(data);
      setState(() {});
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Card(
        child: ListTile(title: Text(data[index]["title"])),
      );
    }));
  }
}
