import 'package:barcode_manager_flutter/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings',
          style: TextStyle(fontFamily: 'family'.tr()),
        ).tr(),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('language'.tr(), style: const TextStyle(fontSize: 18)),
                  DropdownButton<String>(
                    value: context.locale.languageCode,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: CColors.purple),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: CColors.purple,
                    ),
                    onChanged: (data) {
                      if (data != null) {
                        context.setLocale(Locale(data));
                      }
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'en',
                        child: Text(
                          'English',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ar',
                        child: Text(
                          'العربية',
                          style: TextStyle(fontFamily: 'Arabic'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text('Powered By Majd Zain Al Deen',
                  style: TextStyle(fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ),
    );
  }
}
