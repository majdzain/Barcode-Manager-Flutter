import 'dart:convert';
import 'dart:typed_data';

String decryptText(Encoding codec, Uint8List bytes) {
  final decoded = codec.decode(bytes.toList());
  return decoded;
}
