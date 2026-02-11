import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/utils/widgets/image_bottomsheet.dart';

class ReverifyAadharController extends GetxController {
  var reverifyformKeyAadhar = GlobalKey<FormState>();
  TextEditingController aadhaarTextController = TextEditingController();
  TextEditingController aadharOTP = TextEditingController();
  TextEditingController document = TextEditingController();
  File? file;

  @override
  void onInit() {
    super.onInit();
  }

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
