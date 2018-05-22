import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.LOOPBACK_IP_V4,
    3000,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    try {
      var body = await request
          .map((lis) => new String.fromCharCodes(lis))
          .join('');
      var json = JSON.decode(body);
      request.response
        ..write(JSON.encode(json))
        ..close();
    } catch (ex) {
      request.response
        ..write(ex)
        ..close();
    }
  }
}