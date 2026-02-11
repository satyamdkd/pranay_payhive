import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/modules/address/repo/address_repo.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:location/location.dart' as loc;

import '../../../utils/widgets/image_bottomsheet.dart';

class AddressController extends GetxController {
  AddressRepo repo = AddressRepo();

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  TextEditingController address = TextEditingController();
  TextEditingController completeAddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  RxInt locationTypeSelection = 1.obs;

  RxBool isLoadingAddress = false.obs;
  var addressFormKey = GlobalKey<FormState>();

  validateAddressForm() {
    final isValid = addressFormKey.currentState!.validate();
    if (!isValid) {
      return null;
    } else if (doc == null) {
      errorDialog(
        context: Get.context!,
        message: 'Please choose address proof document',
      );
    } else {
      addAddress();
    }

    update();
  }

  getUserData() async {}

  RxBool isDeleting = false.obs;
  String? addressId;

  deleteAddress() async {
    try {
      isDeleting.value = true;
      update();
      final response = await repo.deleteAddress(
        addressId: addressId!,
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
      isDeleting.value = false;
      update();
    }
  }

  defaultAddress() async {
    try {
      isDeleting.value = true;
      update();
      final response = await repo.defaultAddress(
        addressId: addressId!,
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
      isDeleting.value = false;
      update();
    }
  }

  File? doc;

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  pickDocument(context) async {
    AppBottomSheet.kImagePickerBottomSheet(
      context,
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

  TextEditingController document = TextEditingController();
  pickMyFile(ImageSource source) async {
    XFile? image = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      doc = File(image.path);
      document.text = image.name;
      update();
    }
  }

  addAddress() async {
    try {
      isLoadingAddress.value = true;
      update();
      final response = await repo.addAddress(
        address: address.text,
        completeAddress: completeAddress.text,
        city: city.text,
        state: state.text,
        country: country.text,
        pincode: pincode.text,
        landmark: landmark.text,
        latitude: latitude.text,
        longitude: longitude.text,
        addressproof: doc,
      );

      if (response is ApiSuccess) {
        final data = response.data;
        if (data['status'] == 1) {
          Get.back();
          Get.back();
          Get.back();
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingAddress.value = false;
      update();
    }
  }

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "Payhive",
      color: appColors.red,
    );
  }

  RxBool isMapOpened = false.obs;

  loc.LocationData? currentLoc;

  double currentLat = 0.0;
  double currentLong = 0.0;

  RxBool permissionGranted = false.obs;
  loc.Location location = loc.Location();

  int counter = 0;
  handleLocationPermission() async {
    if (loc.PermissionStatus.granted == await location.requestPermission()) {
      if (!await location.serviceEnabled() &&
          !await location.requestService()) {
        return;
      }
      if (await location.hasPermission() == loc.PermissionStatus.denied &&
          await location.requestPermission() != loc.PermissionStatus.granted) {
        return;
      }

      try {
        counter++;
        currentLoc = await location.getLocation();
        location.enableBackgroundMode(enable: false);

        if (currentLoc != null) {
          currentLat = currentLoc!.latitude!;
          currentLong = currentLoc!.longitude!;

          if (currentLatThatIsFixed == null) {
            currentLatThatIsFixed = currentLoc!.latitude!;
            currentLongThatIsFixed = currentLoc!.longitude!;
          }

          debugPrint(
              "(counter : $counter) ${currentLoc!.latitude} ${currentLoc!.longitude}, fixed : $currentLatThatIsFixed, $currentLongThatIsFixed");
        }
      } on Exception {
        log("Exception Location");
      }
    } else {
      showSnackBar(
        message: "Location permission is required.",
        title: "Permission required",
        color: appColors.red,
      );
    }
  }

  Map<String, String?> parseAddress(String passedAddress) {
    address.text = passedAddress;

    List<String> parts = address.text.split(RegExp(r'[ ,]'));

    pincode.text = parts.lastWhere(
      (part) => int.tryParse(part) != null,
      orElse: () => '',
    );

    final cleanedAddress = passedAddress.endsWith('.')
        ? passedAddress.substring(0, passedAddress.length - 1)
        : passedAddress;

    final part = cleanedAddress.split(',').map((part) => part.trim()).toList();

    final result = <String, String?>{
      'city': null,
      'state': null,
      'county': null,
    };

    if (parts.length >= 4) {
      result['city'] = part[part.length - 3];

      result['state'] = part[part.length - 3];

      result['county'] = part.length >= 3 ? part[part.length - 4] : null;
    }

    state.text = result['state'] ?? '';
    city.text = result['city'] ?? '';
    country.text = result['county'] ?? '';
    update();

    return result;
  }

  double? currentLatThatIsFixed;
  double? currentLongThatIsFixed;

  String titleAddressToShow = '';
  String fullAddressToShow = '';
}
