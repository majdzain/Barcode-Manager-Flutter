import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:barcode_manager_flutter/widgets/scanner_panel_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_manager_flutter/widgets/scanner_overlay_shape.dart';
import 'package:scan/scan.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vibration/vibration.dart';

class ScannerScreen extends StatefulWidget {
  final Function(bool isWifi, {String? text, String? ssid, String? password})
      onEdit;
  const ScannerScreen({required this.onEdit, Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? _imagePath;
  final MobileScannerController _controller = MobileScannerController();
  List<Barcode> _barcodes = [];
  final PanelController _panelController = PanelController();
  String? _scanError;

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * .40,
      minHeight: 71,
      parallaxEnabled: true,
      controller: _panelController,
      parallaxOffset: .5,
      isDraggable: _barcodes.isNotEmpty,
      panelBuilder: (sc) => ScannerPanelWidget(
          barcodes: _barcodes, onEdit: widget.onEdit, scrollController: sc),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      body: Stack(
        children: [
          _imagePath != null
              ? Image.file(File(_imagePath!))
              : MobileScanner(
                  controller: _controller,
                  onDetect: (capture) async {
                    if (capture.barcodes.isNotEmpty) {
                      if ((await Vibration.hasVibrator()) ?? false) {
                        Vibration.vibrate();
                      }
                      _panelController.animatePanelToPosition(1.0);
                      setState(() {
                        _scanError = null;
                        _barcodes = capture.barcodes;
                      });
                    } else {
                      setState(() {
                        _scanError = 'invalid_barcode'.tr();
                        _barcodes = [];
                      });
                    }
                  }),
          _imagePath == null
              ? Container(
                  decoration: ShapeDecoration(
                      shape: ScannerOverlayShape(
                  borderColor: CColors.purple,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: scanArea,
                  cutOutBottomOffset: 80,
                )))
              : Container(),
          _scanError != null
              ? Center(
                  child: Text(
                    _scanError!,
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'family'.tr(),
                        fontSize: 18),
                  ),
                )
              : Container(),
          _imagePath == null
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _controller.toggleTorch();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                child: ValueListenableBuilder<TorchState>(
                                    valueListenable: _controller.torchState,
                                    builder: (BuildContext context,
                                        TorchState state, Widget? child) {
                                      return Icon(
                                          state == TorchState.on
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                          color: CColors.purple,
                                          size: 33);
                                    }))),
                        const SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {
                              _controller.switchCamera();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)),
                              child: const Icon(Icons.flip_camera_android,
                                  color: CColors.purple, size: 33),
                            ))
                      ],
                    ),
                  ))
              : Container(),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          if (_imagePath != null) {
                            setState(() {
                              _imagePath = null;
                            });
                          } else {
                            final ImagePicker picker = ImagePicker();
                            final XFile? file = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (file != null) {
                              setState(() {
                                _imagePath = file.path;
                              });
                              String? res = await Scan.parse(_imagePath!);
                              if (res == null) {
                                setState(() {
                                  _scanError = 'invalid_barcode'.tr();
                                  _barcodes = [];
                                });
                              } else {
                                if ((await Vibration.hasVibrator()) ?? false) {
                                  Vibration.vibrate();
                                }
                                _panelController.animatePanelToPosition(1.0);
                                setState(() {
                                  _scanError = null;
                                  _barcodes = [
                                    Barcode(
                                        rawValue: res,
                                        rawBytes:
                                            Uint8List.fromList(res.codeUnits),
                                        type: BarcodeType.text)
                                  ];
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Icon(
                              _imagePath != null
                                  ? Icons.camera_alt
                                  : Icons.image,
                              color: CColors.purple,
                              size: 35),
                        )),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
