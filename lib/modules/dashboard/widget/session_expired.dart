import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/pages.dart';
import '../../../services/di/di.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: appColors.white,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_off_outlined,
                  size: 80,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Session Expired',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your session has expired.\nPlease login again to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    salariedController.mobileController.clear();
                    salariedController.isLoginScreenDisabled.value = false;
                    salariedController.isOTPShotPhone.value = false;
                    salariedController.isIgnoringMobile.value = false;
                    salariedController.isEditingPhone.value = true;

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();

                    Get.offAllNamed(Routes.splash);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
