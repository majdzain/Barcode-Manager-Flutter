import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:barcode_manager_flutter/utils/constants/codec_type_names.dart';
import 'package:clipboard/clipboard.dart';
import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:barcode_manager_flutter/utils/functions/display_snackbar.dart';
import 'package:barcode_manager_flutter/utils/functions/encrypt_text.dart';
import 'package:barcode_manager_flutter/utils/functions/get_codec_type_from_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GeneratorScreen extends StatefulWidget {
  final bool? isWifi;
  final bool isEdit;
  final String? text;
  final String? ssid;
  final String? password;
  const GeneratorScreen({
    this.text,
    required this.isEdit,
    this.isWifi,
    this.ssid,
    this.password,
    Key? key,
  }) : super(key: key);

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  String _code = '';
  TextEditingController _controller = TextEditingController();
  TextEditingController _ssidController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _errorText, _ssidErrorText, _passwordErrorText;
  BarcodeType _currentType = BarcodeType.QrCode;
  String __currentEncodingTypeName = 'default'.tr();
  Encoding? _currentEncodingType;
  bool _isLoading = false;
  File? _barcodeFile;
  String? _barcodeError;
  bool _isWifi = false;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _isWifi = widget.isWifi!;
      if (widget.isWifi!) {
        _ssidController = TextEditingController(text: widget.ssid!);
        _passwordController = TextEditingController(text: widget.password!);
      } else {
        _code = widget.text!;
        _controller = TextEditingController(text: widget.text);
      }
    }
  }

  void _generate(String txt) async {
    setState(() {
      _isLoading = true;
      _barcodeError = null;
    });
    String text = txt;
    final barcode = Barcode.fromType(_currentType);
    double width = 200, height = 80;
    String svg = '';
    if (barcode.name == BarcodeType.Aztec.name ||
        barcode.name == BarcodeType.QrCode.name ||
        barcode.name == BarcodeType.DataMatrix.name) {
      width = 400;
      height = 400;
    }
    try {
      if (_currentEncodingType != null) {
        Uint8List encodedBytes = encryptText(_currentEncodingType!, txt);
        String encodedText = String.fromCharCodes(encodedBytes);
        text = encodedText;
        svg = barcode.toSvgBytes(encodedBytes, width: width, height: height);
      } else {
        svg = barcode.toSvg(_code, width: width, height: height);
      }
      File file =
          await File('${(await getTemporaryDirectory()).path}/barcode.svg')
              .writeAsString(svg);
      setState(() {
        _barcodeFile = file;
        _barcodeError = null;
        _code = text;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _barcodeError = 'can_not_generate_barcode'.tr();
      });
    }
  }

  void _generateWifi(String ssid, String password) async {
    setState(() {
      _isLoading = true;
      _barcodeError = null;
    });
    final barcode = Barcode.fromType(_currentType);
    double width = 200, height = 80;
    String svg = '';
    if (barcode.name == BarcodeType.Aztec.name ||
        barcode.name == BarcodeType.QrCode.name ||
        barcode.name == BarcodeType.DataMatrix.name) {
      width = 400;
      height = 400;
    }
    try {
      final me = MeCard.wifi(
        ssid: ssid,
        password: password,
      );
      svg = barcode.toSvg(me.toString(), width: width, height: height);
      File file =
          await File('${(await getTemporaryDirectory()).path}/barcode.svg')
              .writeAsString(svg);
      setState(() {
        _barcodeFile = file;
        _barcodeError = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _barcodeError = 'can_not_generate_barcode'.tr();
      });
    }
  }

  void _onSubmitted(String txt) {
    FocusScope.of(context).unfocus();
    if (txt.isNotEmpty) {
      setState(() {
        _errorText = null;
      });
      _generate(txt);
    } else {
      setState(() {
        _errorText = 'error_type_text'.tr();
      });
    }
  }

  void _onSubmittedWifi(String ssid, String password) {
    FocusScope.of(context).unfocus();
    if (ssid.isNotEmpty) {
      setState(() {
        _ssidErrorText = null;
      });
      _generateWifi(ssid, password);
    } else if (password.isNotEmpty) {
      setState(() {
        _passwordErrorText = null;
      });
      _generateWifi(ssid, password);
    } else {
      setState(() {
        _errorText = 'error_type_text'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: _isLoading || _barcodeFile == null || _barcodeError != null
                  ? Center(
                      child: _barcodeError != null
                          ? Text(
                              _barcodeError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red, fontFamily: 'family'.tr()),
                            )
                          : _isLoading
                              ? const CircularProgressIndicator(
                                  color: CColors.purple)
                              : const Icon(Icons.qr_code,
                                  color: CColors.purple, size: 70))
                  : SvgPicture.file(
                      _barcodeFile!,
                    ),
            ),
            const SizedBox(height: 10),
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
                  Text('barcode_type'.tr(),
                      style:
                          TextStyle(fontSize: 16, fontFamily: 'family'.tr())),
                  DropdownButton<BarcodeType>(
                      value: _currentType,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: CColors.purple),
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
                            _currentType = data;
                          });
                          if (_controller.text.isNotEmpty) {
                            _generate(_controller.text);
                          }
                        }
                      },
                      items: BarcodeType.values
                          .map<DropdownMenuItem<BarcodeType>>(
                              (e) => DropdownMenuItem<BarcodeType>(
                                    value: e,
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                          color: e == _currentType
                                              ? CColors.purple
                                              : null),
                                    ),
                                  ))
                          .toList()),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text(
                'wifi_qr_code'.tr(),
                style: TextStyle(
                  fontFamily: 'family'.tr(),
                ),
              ),
              value: _isWifi,
              onChanged: (newValue) {
                setState(() {
                  _isWifi = !_isWifi;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            _isWifi
                ? SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextField(
                      cursorColor: CColors.purple,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'family'.tr(),
                      ),
                      controller: _ssidController,
                      onChanged: (txt) {
                        if (txt.isNotEmpty) {
                          setState(() {
                            _ssidErrorText = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'ssid'.tr(),
                        labelStyle: TextStyle(
                          color: CColors.purple,
                          fontFamily: 'family'.tr(),
                        ),
                        errorText: _ssidErrorText,
                        errorStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'family'.tr(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: CColors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 3.0,
                            color: CColors.purple,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 3.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ))
                : Container(),
            _isWifi ? const SizedBox(height: 10) : Container(),
            _isWifi
                ? SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextField(
                      cursorColor: CColors.purple,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'family'.tr(),
                      ),
                      controller: _passwordController,
                      onChanged: (txt) {
                        if (txt.isNotEmpty) {
                          setState(() {
                            _passwordErrorText = null;
                          });
                        }
                      },
                      onSubmitted: (txt) {
                        if (txt.isNotEmpty) {
                          _onSubmittedWifi(
                              _ssidController.text, _passwordController.text);
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'password'.tr(),
                        labelStyle: TextStyle(
                          color: CColors.purple,
                          fontFamily: 'family'.tr(),
                        ),
                        errorText: _passwordErrorText,
                        errorStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'family'.tr(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: CColors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 3.0,
                            color: CColors.purple,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                            width: 3.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ))
                : Container(),
            _isWifi
                ? ElevatedButton(
                    onPressed: () {
                      _onSubmittedWifi(
                          _ssidController.text, _passwordController.text);
                    },
                    child: Text('generate'.tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'family'.tr())))
                : Container(),
            !_isWifi
                ? Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: CColors.purple, width: 2)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('encoding_type'.tr(),
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'family'.tr())),
                        DropdownButton<String>(
                            value: __currentEncodingTypeName,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: CColors.purple),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            underline: Container(
                              height: 2,
                              color: CColors.purple,
                            ),
                            onChanged: (data) {
                              if (data != null) {
                                setState(() {
                                  __currentEncodingTypeName = data;
                                  _currentEncodingType =
                                      getCodecTypeFromName(data);
                                });
                                if (_controller.text.isNotEmpty) {
                                  _generate(_controller.text);
                                }
                              }
                            },
                            items: codecTypeNames
                                .map<DropdownMenuItem<String>>(
                                    (e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                color: e ==
                                                        __currentEncodingTypeName
                                                    ? CColors.purple
                                                    : null),
                                          ),
                                        ))
                                .toList()),
                      ],
                    ),
                  )
                : Container(),
            !_isWifi ? const SizedBox(height: 8) : Container(),
            !_isWifi
                ? SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: CColors.purple,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'family'.tr(),
                            ),
                            controller: _controller,
                            onSubmitted: _onSubmitted,
                            onChanged: (txt) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'text'.tr(),
                              labelStyle: TextStyle(
                                color: CColors.purple,
                                fontFamily: 'family'.tr(),
                              ),
                              errorText: _errorText,
                              errorStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: 'family'.tr(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: CColors.purple,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  width: 3.0,
                                  color: CColors.purple,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  width: 3.0,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 8,
                          ),
                        ),
                        _controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _onSubmitted(_controller.text);
                                },
                                icon: const Icon(Icons.done_rounded,
                                    color: CColors.purple, size: 27))
                            : Container()
                      ],
                    ),
                  )
                : Container(),
            !_isWifi && _code.isNotEmpty
                ? const SizedBox(height: 10)
                : Container(),
            !_isWifi && _code.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      _code,
                      style: TextStyle(
                        fontFamily: 'family'.tr(),
                      ),
                    ),
                  )
                : Container(),
            !_isWifi && _code.isNotEmpty
                ? const SizedBox(height: 10)
                : Container(),
            !_isWifi && _code.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            FlutterClipboard.copy(_code).then((value) =>
                                displaySnackbar(
                                    context, 'encrypted_text_copied'.tr()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.copy,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 3),
                                Text(
                                  'copy_encrypted_text'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'family'.tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _code.isNotEmpty
                            ? const SizedBox(height: 5)
                            : Container(),
                        ElevatedButton(
                          onPressed: () async {
                            if (_barcodeFile != null) {
                              var externalDirectoryPath =
                                  (await getExternalStorageDirectory())!;
                              Directory(
                                      '${externalDirectoryPath.path}/Code Images')
                                  .create()
                                  .then((Directory directory) async {
                                final filePath = path.join(directory.path,
                                    "barcode_${DateTime.now().toIso8601String()}.svg");
                                File imgFile = File(filePath);
                                imgFile
                                    .writeAsBytes(
                                        await _barcodeFile!.readAsBytes())
                                    .then((value) {
                                  displaySnackbar(context,
                                      '${'saved_in'.tr()}: ${externalDirectoryPath.path}/Barcodes');
                                }).catchError((onError) {
                                  setState(() {
                                    _code = onError.toString();
                                  });
                                });
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 3),
                                Text(
                                  'save_as_image'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'family'.tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
          ]),
    );
  }
}
