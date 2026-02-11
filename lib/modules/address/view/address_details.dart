import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/modules/address/controller/address_controller.dart';
import 'package:payhive/modules/address/view/location_pick.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addressDetailText(),
              addAddress(context),
            ],
          ),
        ),
      ),
    );
  }

  Container addAddress(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: width / 20, right: width / 20),
      height: MediaQuery.sizeOf(context).height / 1.4,
      decoration: boxDecorationMainMobileWidget(),
      child: GetBuilder<AddressController>(
          init: controller,
          builder: (cxt) {
            return Form(
              key: controller.addressFormKey,
              child: Column(
                children: [
                  spacing(),
                  enterFullName(
                    controller.address,
                    Icons.location_searching_rounded,
                    onChange: (v) {
                      controller.address.text =
                          capitalizeFirstCharacter(v.toString());
                      controller.update();
                    },
                    'Search address.',
                    (value) => FormValidation.name(controller.address.text),
                    context: context,
                  ),
                  spacing(passedHeight: height / 30),
                  inputField(
                    controller.state,
                    null,
                    'State',
                    onChange: (v) {
                      controller.state.text =
                          capitalizeFirstCharacter(v.toString());
                      controller.update();
                    },
                    context: context,
                  ),
                  spacing(passedHeight: height / 30),
                  Row(
                    children: [
                      Expanded(
                        child: inputField(
                          controller.city,
                          null,
                          'City',
                          onChange: (v) {
                            controller.state.text =
                                capitalizeFirstCharacter(v.toString());
                            controller.update();
                          },
                          context: context,
                        ),
                      ),
                      SizedBox(width: width / 30),
                      Expanded(
                        child: inputField(
                          controller.pincode,
                          keyboardType: TextInputType.number,
                          null,
                          'Pincode',
                          onChange: (v) {
                            controller.state.text =
                                capitalizeFirstCharacter(v.toString());
                            controller.update();
                          },
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  spacing(passedHeight: height / 30),
                  addressText(),
                  spacer(),
                  spacing(passedHeight: height / 50),
                  !controller.isLoadingAddress.value
                      ? customButton(
                          title: "Submit",
                          context: context,
                          onTap: () {
                            controller.validateAddressForm();
                          },
                        )
                      : Lottie.asset('assets/lottie/wave_loading.json',
                          width: width / 2, height: height / 3.5),
                  spacing(passedHeight: height / 8),
                ],
              ),
            );
          }),
    );
  }

  Container addressText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: width / 80),
      child: Text(
        "Enter your address to complete the verification process and ensure accurate records.",
        style: theme.textTheme.labelLarge?.copyWith(
          color: appColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget addressDetailText() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: width / 40, bottom: height / 40),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(top: height / 20),
                child: Icon(
                  CupertinoIcons.back,
                  color: appColors.white,
                  size: height / 10,
                ),
              ),
            ),
            Text(
              "  Enter Your Address",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: appColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration boxDecorationMainMobileWidget() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage("assets/images/bg_drop_down.png"),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(height / 16),
        topLeft: Radius.circular(height / 16),
      ),
    );
  }

  SizedBox spacing({passedHeight}) =>
      SizedBox(height: passedHeight ?? height / 20);

  Spacer spacer() => const Spacer();

  InkWell enterFullName(
      textEditingController, icon, tag, String? Function(Object?)? validator,
      {onChange, TextInputType? keyboardType, context}) {
    return InkWell(
      onTap: () => onTap(context),
      child: IgnorePointer(
        ignoring: true,
        child: customTextField(
          textEditingController: textEditingController,
          title: "",
          fullTag: tag,
          readOnly: true,
          onChanged: onChange,
          fontSize: height / 26,

          /// prefixIcon: Container(
          ///   padding: EdgeInsets.symmetric(
          ///     vertical: height / 30,
          ///     horizontal: width / 40,
          ///   ),
          ///   child: Icon(
          ///     icon,
          ///     color: appColors.primaryColor.withOpacity(0.6),
          ///   ),
          /// ),

          suffixIcon: controller.isMapOpened.value
              ? Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height / 30,
                    horizontal: width / 30,
                  ),
                  child: CupertinoActivityIndicator(
                    color: appColors.primaryLight,
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height / 30,
                    horizontal: width / 40,
                  ),
                  child: Icon(
                    icon,
                    color: appColors.primaryColor.withOpacity(0.6),
                  ),
                ),
          keyboardType: keyboardType ?? TextInputType.text,
        ),
      ),
    );
  }

  Widget inputField(
    textEditingController,
    icon,
    tag, {
    onChange,
    TextInputType? keyboardType,
    context,
  }) {
    return customTextField(
      textEditingController: textEditingController,
      title: "",
      fullTag: tag,
      readOnly: false,
      onChanged: onChange,
      fontSize: height / 26,
      prefixIcon: icon != null
          ? Container(
              padding: EdgeInsets.symmetric(
                vertical: height / 30,
                horizontal: width / 40,
              ),
              child: Icon(
                icon,
                color: appColors.primaryColor.withOpacity(0.6),
              ),
            )
          : null,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }

  void onTap(context) async {
    controller.isMapOpened.value = true;
    controller.update();
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

    await Future.delayed(Duration.zero, () async {
      await controller.handleLocationPermission();
    });

    if (loc.PermissionStatus.granted ==
        await controller.location.requestPermission()) {
      if (controller.currentLat != 0.0) {
        controller.isMapOpened.value = false;
        controller.update();
        // Get.to(
        //   () => LocationPickerPage(),
        //   transition: Transition.rightToLeft,
        //   duration: const Duration(seconds: 1),
        // );
      } else {
        showSnackBar(
          message: "Please wait your location is being fetched.",
          title: "Location",
        );
      }
    } else {
      await openAppSettings();
    }
  }
}
