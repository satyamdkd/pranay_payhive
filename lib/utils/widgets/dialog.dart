import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

logoutDialog({
  VoidCallback? onTap,
  String? buttonTitle,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Column(
          children: [
            Image.asset(
              "assets/images/logout_icon.png",
              height: height / 8,
              width: height / 8,
            ),
            SizedBox(height: height / 80),
            Text(
              "Logout?",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                  fontSize: height / 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height / 120),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Are you sure you want to logout?",
              style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xff52575C),
                  fontSize: height / 28,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 4,
                height: height / 10,
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: appColors.white,
                    minimumSize: const Size(88, 36),
                    side:
                        const BorderSide(width: 0.8, color: Color(0xff303F9F)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "No",
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xff303F9F),
                        fontWeight: FontWeight.w500,
                        fontSize: height / 28),
                  ),
                ),
              ),
              SizedBox(width: width / 20),
              SizedBox(
                width: width / 4,
                height: height / 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(88, 36),
                    backgroundColor: const Color(0xff303F9F),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  onPressed: () {
                    sharedPref.clearSharedPref();
                    Future.delayed(Duration.zero, () {
                      ///  Get.offAll(() => const Login());
                    });
                  },
                  child: Text(
                    "Yes",
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: appColors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        fontSize: height / 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      );
    }),
  );
}

phoneNumberDialog({required List<String> phoneNumbers}) {
  return Get.defaultDialog(
    title: '',
    titleStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 0),
    titlePadding: EdgeInsets.zero,
    radius: 4,
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            textAlign: TextAlign.start,
            "Continue with",
            style: theme.textTheme.bodySmall?.copyWith(
              color: appColors.black,
              fontSize: height / 22,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            phoneNumbers.length,
            (ind) => GestureDetector(
              onTap: () {
                salariedController.mobileController.text = phoneNumbers[ind];
                salariedController.update();
                Get.back();
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.4),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          CupertinoIcons.phone,
                          color: appColors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        textAlign: TextAlign.center,
                        "+91 ${phoneNumbers[ind]}",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textDark,
                            fontSize: height / 24,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              salariedController.mobileController.clear();
              salariedController.update();
              Get.back();
            },
            child: Text(
              textAlign: TextAlign.start,
              "NONE OF THE ABOVE",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.blue,
                fontSize: height / 32,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
