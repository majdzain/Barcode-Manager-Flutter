import 'package:barcode_manager_flutter/pages/settings_page.dart';
import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:barcode_manager_flutter/screens/generator_screen.dart';
import 'package:barcode_manager_flutter/screens/scanner_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? content;
  bool isScan = false;

  void openScanner() {
    setState(() {
      content = ScannerScreen(
        onEdit: (isWifi, {password, ssid, text}) {
          setState(() {
            content = GeneratorScreen(
              isEdit: true,
              isWifi: isWifi,
              text: text,
              ssid: ssid,
              password: password,
            );
            isScan = false;
          });
        },
      );
      isScan = true;
    });
  }

  void openGenerator(String? co) {
    setState(() {
      content = const GeneratorScreen(
        isEdit: false,
      );
      isScan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    content ??= const GeneratorScreen(
      isEdit: false,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'barcode_manager'.tr(),
            style: TextStyle(
              fontFamily: 'family'.tr(),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const SettingsPage())),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: isScan ? Colors.black : Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                      color: CColors.purple,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  isScan ? Colors.white : CColors.purple,
                                ),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: !isScan
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: CColors.purple,
                                                width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              if (isScan) {
                                openGenerator(null);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code_2_rounded,
                                  color:
                                      !isScan ? Colors.white : CColors.purple,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text('generator'.tr(),
                                    style: TextStyle(
                                        color: !isScan
                                            ? Colors.white
                                            : CColors.purple,
                                        fontSize: 18,
                                        fontFamily: 'family'.tr(),
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  !isScan ? Colors.white : CColors.purple,
                                ),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: isScan
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: CColors.purple,
                                                width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              if (!isScan) {
                                openScanner();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: isScan ? Colors.white : CColors.purple,
                                ),
                                const SizedBox(width: 3),
                                Text('scanner'.tr(),
                                    style: TextStyle(
                                      color: isScan
                                          ? Colors.white
                                          : CColors.purple,
                                      fontSize: 18,
                                      fontFamily: 'family'.tr(),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Expanded(child: Center(child: content)),
            ]));
  }
}
