import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:barcode_manager_flutter/utils/functions/display_snackbar.dart';
import 'package:barcode_manager_flutter/utils/functions/get_barcode_icon.dart';
import 'package:barcode_manager_flutter/utils/functions/get_barcode_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerBarcodeWidget extends StatelessWidget {
  final Barcode barcode;
  final Encoding? codec;
  final Function(bool isWifi, {String? text, String? ssid, String? password})
      onEdit;

  const ScannerBarcodeWidget(
      {required this.barcode, this.codec, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: CColors.purple, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(getBarcodeIcon(barcode.type), color: Colors.white, size: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getBarcodeWidgets(barcode, codec),
              ),
            ),
            barcode.type != BarcodeType.wifi &&
                        (barcode.rawValue != null ||
                            barcode.displayValue != null) ||
                    (barcode.type == BarcodeType.wifi &&
                        barcode.wifi?.ssid != null &&
                        barcode.wifi?.password != null)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (barcode.type == BarcodeType.wifi) {
                              onEdit(true,
                                  ssid: barcode.wifi!.ssid,
                                  password: barcode.wifi!.password);
                            } else {
                              onEdit(false,
                                  text: barcode.rawValue ??
                                      barcode.displayValue!);
                            }
                          },
                          icon: const Icon(Icons.edit, color: Colors.white)),
                      IconButton(
                          onPressed: () {
                            String copiedText = '';
                            if (barcode.type == BarcodeType.wifi) {
                              copiedText =
                                  '${'ssid'.tr()}: ${barcode.wifi!.ssid!}\n${'password'.tr()}: ${barcode.wifi!.password!}';
                            } else {
                              copiedText =
                                  barcode.rawValue ?? barcode.displayValue!;
                            }
                            FlutterClipboard.copy(copiedText).then((value) =>
                                displaySnackbar(context, 'text_copied'.tr()));
                          },
                          icon: const Icon(Icons.copy, color: Colors.white))
                    ],
                  )
                : Container(),
          ],
        ));
  }
}
