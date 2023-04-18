import 'dart:convert';
import 'dart:typed_data';

Uint8List encryptText(Encoding codec, String text) {
  final encoded = codec.encode(text);
  String hex = '';
  for (int i = 0; i < encoded.length; i++) {
    hex +=
        // ('%u' +
        ' ' + encoded[i].toRadixString(16);
    // );
  }
  return Uint8List.fromList(encoded);
}
