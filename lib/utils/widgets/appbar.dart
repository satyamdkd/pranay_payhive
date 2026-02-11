import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions,
      this.backgroundColor,
      this.onTap,
      this.showNotification = true,
      this.logoutButton = false,
      this.drawerOnTap,
      this.context,
      this.showDrawer = false});

  final bool showNotification;
  final bool logoutButton;

  final void Function()? onTap;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  final Color? backgroundColor;

  final void Function()? drawerOnTap;

  final BuildContext? context;
  final bool showDrawer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appColors.white,
      shadowColor: appColors.grey.withOpacity(0.4),
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Builder(
        builder: (context) {
          return SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!showDrawer)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: width / 30,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: width / 12,
                        color: appColors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                if (showDrawer)
                  Image.asset(
                    "assets/images/afpi_logo.png",
                    height: height / 12,
                    fit: BoxFit.contain,
                  ),
                const Spacer(),
                SizedBox(width: logoutButton ? height / 38 : height / 14),
                if (showDrawer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                        ///  Get.to(() => const PersonalInfo());
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: width / 30, bottom: width / 50),
                          child: Image.asset(
                            "assets/images/home_person.png",
                            height: height / 16,
                            width: height / 16,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: drawerOnTap,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: width / 30, bottom: width / 50),
                          child: Image.asset(
                            "assets/images/drawer.png",
                            height: height / 12,
                            width: height / 12,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      actions: [Container()],
    );
  }

  final MediaQueryData mediaQueryData = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single);

  @override
  Size get preferredSize {
    if (kDebugMode) {
      print(width);
    }
    return Size(0, height / 8);
  }
}
