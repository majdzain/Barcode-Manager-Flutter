import 'dart:convert';

import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:barcode_manager_flutter/utils/constants/codec_type_names.dart';
import 'package:barcode_manager_flutter/utils/functions/get_codec_type_from_name.dart';
import 'package:barcode_manager_flutter/widgets/scanner_barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPanelWidget extends StatefulWidget {
  final List<Barcode> barcodes;
  final ScrollController scrollController;
  final Function(bool isWifi, {String? text, String? ssid, String? password})
      onEdit;
  const ScannerPanelWidget(
      {required this.barcodes,
      required this.onEdit,
      required this.scrollController,
      super.key});

  @override
  State<ScannerPanelWidget> createState() => _ScannerPanelWidgetState();
}

class _ScannerPanelWidgetState extends State<ScannerPanelWidget> {
  String currentDecodingTypeName = 'default'.tr();
  Encoding? currentDecodingType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.barcodes.isNotEmpty ? 'scan_results' : 'no_results',
              style: TextStyle(fontSize: 20.0, fontFamily: 'family'.tr()),
            ).tr(),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: CColors.purple, width: 2)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('decoding_type'.tr(),
                  style: TextStyle(fontSize: 16, fontFamily: 'family'.tr())),
              DropdownButton<String>(
                  value: currentDecodingTypeName,
                  icon:
                      const Icon(Icons.arrow_drop_down, color: CColors.purple),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: CColors.purple,
                  ),
                  onChanged: (data) {
                    if (data != null) {
                      setState(() {
                        currentDecodingTypeName = data;
                        currentDecodingType = getCodecTypeFromName(data);
                      });
                    }
                  },
                  items: codecTypeNames
                      .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: e == currentDecodingTypeName
                                          ? CColors.purple
                                          : null),
                                ),
                              ))
                      .toList()),
            ],
          ),
        ),
        ListView.separated(
            key: Key(currentDecodingTypeName),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, index) {
              return ScannerBarcodeWidget(
                  barcode: widget.barcodes[index], onEdit: widget.onEdit);
            },
            separatorBuilder: (_, __) {
              return const SizedBox(height: 8);
            },
            itemCount: widget.barcodes.length)
      ],
    );
  }
}
