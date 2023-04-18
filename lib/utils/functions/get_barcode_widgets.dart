import 'dart:convert';

import 'package:barcode_manager_flutter/utils/functions/decrypt_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart' as intl;

List<Widget> getBarcodeWidgets(Barcode barcode, Encoding? codec) {
  List<Widget> widgets = [];
  switch (barcode.type) {
    case BarcodeType.text:
      widgets.add(Text(
        codec != null && barcode.rawBytes != null
            ? decryptText(codec, barcode.rawBytes!)
            : barcode.rawValue ??
                barcode.displayValue ??
                'no_barcode_info'.tr(),
        style: const TextStyle(color: Colors.white),
      ));
      break;
    case BarcodeType.calendarEvent:
      if (barcode.calendarEvent != null) {
        String? start = barcode.calendarEvent!.start != null
            ? intl.DateFormat('yyyy-MM-dd')
                .format(barcode.calendarEvent!.start!)
            : null;
        String? end = barcode.calendarEvent!.end != null
            ? intl.DateFormat('yyyy-MM-dd').format(barcode.calendarEvent!.end!)
            : null;
        List<Widget> headerWidgets = [
          start != null
              ? Text(
                  start,
                  style: const TextStyle(color: Colors.white),
                )
              : Container(),
          barcode.calendarEvent!.organizer != null
              ? Text(
                  barcode.calendarEvent!.organizer!,
                  style: const TextStyle(color: Colors.white),
                )
              : Container(),
          end != null
              ? Text(
                  end,
                  style: const TextStyle(color: Colors.white),
                )
              : Container(),
        ];
        widgets.addAll(headerWidgets);
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            start != null
                ? Text(
                    start,
                    style: const TextStyle(color: Colors.white),
                  )
                : Container(),
          ],
        ));
        widgets.add(Text(
          barcode.calendarEvent!.description ?? barcode.calendarEvent!.summary!,
          style: const TextStyle(color: Colors.white),
        ));
        widgets.add(barcode.calendarEvent!.location != null
            ? Text(
                barcode.calendarEvent!.location!,
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.contactInfo:
      if (barcode.contactInfo != null) {
        widgets.add(Text(
          barcode.contactInfo!.name?.formattedName ??
              barcode.contactInfo!.title ??
              '',
          style: const TextStyle(color: Colors.white),
        ));
        widgets.addAll(barcode.contactInfo!.phones != null
            ? barcode.contactInfo!.phones!
                .map((e) => Text(
                      e.number ?? '',
                      style: const TextStyle(color: Colors.white),
                    ))
                .toList()
            : []);
        widgets.addAll(barcode.contactInfo!.emails
            .map((e) => Text(
                  e.address ?? '',
                  style: const TextStyle(color: Colors.white),
                ))
            .toList());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.email:
      if (barcode.email != null) {
        widgets.add(barcode.email!.address != null
            ? Text(
                barcode.email!.address!,
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.email!.subject != null
            ? Text(
                '${'subject'.tr()}: ${barcode.email!.subject!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.email!.body != null
            ? Text(
                barcode.email!.body!,
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.geo:
      if (barcode.geoPoint != null) {
        widgets.add(barcode.geoPoint!.longitude != null
            ? Text(
                '${'longitude'.tr()}: ${barcode.geoPoint!.longitude!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.geoPoint!.latitude != null
            ? Text(
                '${'latitude'.tr()}: ${barcode.geoPoint!.latitude!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.phone:
      if (barcode.phone != null) {
        widgets.add(barcode.phone!.number != null
            ? Text(
                '${'phone_number'.tr()}: ${barcode.phone!.number!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.sms:
      if (barcode.sms != null) {
        widgets.add(barcode.sms!.phoneNumber != null
            ? Text(
                '${'phone_number'.tr()}: ${barcode.sms!.phoneNumber!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.sms!.message != null
            ? Text(
                '${'message'.tr()}: ${barcode.sms!.message!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.url:
      if (barcode.url != null) {
        widgets.add(barcode.url!.title != null
            ? Text(
                barcode.url!.title!,
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.url!.url != null
            ? Text(
                barcode.url!.url!,
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    case BarcodeType.wifi:
      if (barcode.wifi != null) {
        widgets.add(barcode.wifi!.ssid != null
            ? Text(
                '${'ssid'.tr()}: ${barcode.wifi!.ssid!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
        widgets.add(barcode.wifi!.password != null
            ? Text(
                '${'password'.tr()}: ${barcode.wifi!.password!}',
                style: const TextStyle(color: Colors.white),
              )
            : Container());
      } else if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
      break;
    default:
      if (barcode.displayValue != null || barcode.rawValue != null) {
        widgets.add(Text(
          barcode.displayValue ?? barcode.rawValue!,
          style: const TextStyle(color: Colors.white),
        ));
      } else {
        widgets.add(Text(
          'no_barcode_info'.tr(),
          style: const TextStyle(color: Colors.white),
        ));
      }
  }
  return widgets;
}
