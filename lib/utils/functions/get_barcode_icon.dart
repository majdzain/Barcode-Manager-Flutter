import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

IconData getBarcodeIcon(BarcodeType barcodeType) {
  switch (barcodeType) {
    case BarcodeType.text:
      return Icons.text_snippet;
    case BarcodeType.calendarEvent:
      return Icons.calendar_month;
    case BarcodeType.contactInfo:
      return Icons.contact_phone;
    case BarcodeType.driverLicense:
      return Icons.drive_eta_rounded;
    case BarcodeType.email:
      return Icons.email_rounded;
    case BarcodeType.geo:
      return Icons.gps_fixed_rounded;
    case BarcodeType.isbn:
      return Icons.book_rounded;
    case BarcodeType.phone:
      return Icons.phone;
    case BarcodeType.product:
      return Icons.shopping_bag;
    case BarcodeType.sms:
      return Icons.sms_rounded;
    case BarcodeType.url:
      return Icons.link_rounded;
    case BarcodeType.wifi:
      return Icons.wifi_rounded;
    case BarcodeType.unknown:
      return Icons.question_mark;
  }
}
