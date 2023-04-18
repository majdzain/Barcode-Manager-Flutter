import 'dart:convert';

import 'package:enough_convert/enough_convert.dart';

Encoding? getCodecTypeFromName(String name) {
  switch (name) {
    case 'UTF-8':
      return const Utf8Codec();
    case 'ASCII':
      return const AsciiCodec();
    case 'Latin 1 / ISO 8859-1':
      return const Latin1Codec();
    case 'Latin 2 / ISO 8859-2':
      return const Latin2Codec();
    case 'Latin 3 / ISO 8859-3':
      return const Latin3Codec();
    case 'Latin 4 / ISO 8859-4':
      return const Latin4Codec();
    case 'Latin 5 / ISO 8859-5':
      return const Latin5Codec();
    case 'Latin 6 / ISO 8859-6':
      return const Latin6Codec();
    case 'Latin 7 / ISO 8859-7':
      return const Latin7Codec();
    case 'Latin 8 / ISO 8859-8':
      return const Latin8Codec();
    case 'Latin 9 / ISO 8859-9':
      return const Latin9Codec();
    case 'Latin 10 / ISO 8859-10':
      return const Latin10Codec();
    case 'Latin 11 / ISO 8859-11':
      return const Latin11Codec();
    case 'Latin 13 / ISO 8859-13':
      return const Latin13Codec();
    case 'Latin 14 / ISO 8859-14':
      return const Latin14Codec();
    case 'Latin 15 / ISO 8859-15':
      return const Latin15Codec();
    case 'Latin 16 / ISO 8859-16':
      return const Latin16Codec();
    case 'Windows-1250 / cp-1250':
      return const Windows1250Codec();
    case 'Windows-1251 / cp-1251':
      return const Windows1251Codec();
    case 'Windows-1252 / cp-1252':
      return const Windows1252Codec();
    case 'Windows-1253 / cp-1253':
      return const Windows1253Codec();
    case 'Windows-1254 / cp-1254':
      return const Windows1254Codec();
    case 'Windows-1256 / cp-1256':
      return const Windows1256Codec();
    case 'DOS / cp-850':
      return const CodePage850Codec();
    case 'GBK':
      return const GbkCodec();
    case 'KOI8':
      return const Koi8rCodec();
    case 'Big5':
      return const Big5Codec();
  }
}
