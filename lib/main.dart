import 'dart:io';
import 'package:mime/mime.dart';
import 'package:body_parser/body_parser.dart';
import 'dart:convert';

main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  await for (var request in server) {
//    request.response
//      ..write('hello world')
//      ..close();

    print(request.uri.path);
    if (request.uri.path == '/user') {
      handleRequest(request);
//      request.response
//        ..write('hello job')
//        ..close();
    }

    request.response..close();

  }
}


void handleRequest(HttpRequest request) async {
  try {
    print(request.method);
    print(request.uri.queryParameters['q']);
    print(request.uri.queryParametersAll);

    String boundary = request.headers.contentType.parameters['boundary'];

    String content = await request.transform(new MimeMultipartTransformer(boundary)).join(',');
    print(content);

    await File('test.png')
        .writeAsString(content, mode: FileMode.write);

    request.response..close();
  } catch (e){
    print(e);
  }
}