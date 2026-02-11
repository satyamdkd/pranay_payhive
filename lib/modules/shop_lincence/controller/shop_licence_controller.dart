import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/modules/shop_lincence/repo/shop_licence_repo.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

import '../../../utils/widgets/image_bottomsheet.dart';

class ShopLicenceController extends GetxController {
  ShopLicenceRepo repo = ShopLicenceRepo();
  TextEditingController document = TextEditingController();

  File? file;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  TextEditingController licence = TextEditingController();

  RxBool isLoadingShopLicence = false.obs;
  var shopFormKey = GlobalKey<FormState>();

  validateShopLicenceForm() {
    final isValid = shopFormKey.currentState!.validate();
    if (!isValid) {
      return null;
    } else {
      addBank();
    }

    update();
  }

  getUserData() async {}

  addBank() async {
    try {
      isLoadingShopLicence.value = true;
      update();
      final response = await repo.addShopLicence(
        licence: licence.text,
        shoplicence: file,
      );

      if (response is ApiSuccess) {
        final data = response.data;
        if (data['status'] == 1) {
          Get.back();
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingShopLicence.value = false;
      update();
    }
  }

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "PayLix",
      color: appColors.red,
    );
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  pickDocument() async {
    AppBottomSheet.kImagePickerBottomSheet(
      Get.context!,
      onCameraTap: () async {
        Get.close(1);
        pickMyFile(ImageSource.camera);
      },
      onGalleryTap: () async {
        Get.close(1);
        pickMyFile(ImageSource.gallery);
      },
    );
  }

  final ImagePicker _picker = ImagePicker();

  pickMyFile(ImageSource source) async {
    XFile? image = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      file = File(image.path);
      document.text = image.name;
      update();
    }
  }
}
