import 'package:flutter/material.dart';
import 'package:payhive/constants/string_constants.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/helper/hide_status_bar.dart';
import 'package:payhive/utils/helper/key_board_utils.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:get/get.dart';
import 'package:payhive/services/di/di.dart';

class PayHive extends StatefulWidget {
  const PayHive({super.key});

  @override
  State<PayHive> createState() => _PayHiveState();
}

class _PayHiveState extends State<PayHive> {
  setHeightAndWidth(BuildContext context) {
    height = MediaQuery.sizeOf(context).width;
    width = MediaQuery.sizeOf(context).width;
  }

  @override
  void initState() {
    super.initState();
    setUpDi();
  }

  @override
  Widget build(BuildContext context) {
    setHeightAndWidth(context);
    hideStatusBar();
    return GestureDetector(
      onTap: () => KeyboardUtil.hideKeyboard(context),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: theme,
          title: StringConstants.appName,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        ),
      ),
    );
  }
}
