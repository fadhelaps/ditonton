import 'dart:io';
import 'package:core/core.dart';
import 'package:flutter/services.dart';

Future<HttpClient> getHttpClient() async {
  final sslCert = await rootBundle.load(BASE_SSL_CERT + '/certificates.cer');
  var securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

  var client = HttpClient(context: securityContext);
  client.badCertificateCallback = (cert, host, port) => false;
  return client;
}
