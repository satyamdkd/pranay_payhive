import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final Map<String, GetxController Function()> controllerBindings = {};

  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
    _initCheck();
  }

  Future<void> _initCheck() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);

    if (!hasConnection) {
      isConnected.value = false;
      _showNoInternetDialog();
    } else {
      isConnected.value = true;
      if (Get.isDialogOpen ?? false) {
        Get.back();
        _reLoadPageData();
      }
    }
  }

  void _reLoadPageData() {
    final currentRoute = Get.currentRoute;
    if (controllerBindings.containsKey(currentRoute)) {
      Get.delete(force: true, tag: currentRoute);
      controllerBindings[currentRoute]!();
    }
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titlePadding:
              const EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 10),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 20),
          title: Column(
            children: [
              Icon(Icons.wifi_off,
                  size: 48, color: Colors.redAccent.withValues(alpha: 0.8)),
              const SizedBox(height: 14),
              Text(
                "No Internet!",
                style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: height / 18,
                    letterSpacing: 0.05),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You are not connected to the internet.",
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: height / 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Check your connection\nand try again.",
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                  fontSize: height / 28,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                final results = await _connectivity.checkConnectivity();
                final hasConnection =
                    results.any((r) => r != ConnectivityResult.none);

                if (hasConnection) {
                  Get.back();
                  _reLoadPageData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(110, 40),
                elevation: 0,
              ),
              icon: Icon(
                Icons.refresh,
                size: 20,
                color: appColors.white,
              ),
              label: Text(
                "Retry",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 24,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
