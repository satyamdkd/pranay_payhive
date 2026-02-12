import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/image_bottomsheet.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class ReverifyPanController extends GetxController {
  var reverifyformKeyPan = GlobalKey<FormState>();
  RxBool isAccountTypeSalaried = false.obs;
  TextEditingController panTextController = TextEditingController();
  Map<String, dynamic>? panDetails;
  Map<String, dynamic>? gstDetails;
  RxBool isPanTermChecked = false.obs;
  RxBool isPanLoading = false.obs;
  String panGstNumberSorted = '';
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
    // XFile? image = await _picker.pickImage(
    //   source: source,
    //   preferredCameraDevice: CameraDevice.rear,
    // );
    // if (image != null) {
    //   file = File(image.path);
    //   document.text = image.name;
    //   update();
    // }
  }

  validatePanForm() {
    final isValid = reverifyformKeyPan.currentState!.validate();
    if (!isValid) {
      return null;
    } else {
      if (isPanTermChecked.value) {
        // salariedAPI(step: '7');
      } else {
        showSnackBar(
            message: 'Please tick the above term',
            title: 'Payhive',
            color: appColors.red);
      }
    }

    update();
  }
}
